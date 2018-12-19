package manifests

import (
	"path/filepath"

	"github.com/ghodss/yaml"
	"github.com/pkg/errors"

	"github.com/openshift/installer/pkg/asset"
	"github.com/openshift/installer/pkg/asset/installconfig"
	"github.com/openshift/installer/pkg/asset/templates/content"

	configv1 "github.com/openshift/api/config/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

var (
	authCrdFilename = "cluster-authentication-crd.yaml"
	authCfgFilename = filepath.Join(manifestDir, "cluster-authentication-config.yml")
)

// Authentication generates the authentication-*.yml files.
type Authentication struct {
	config   *configv1.Authentication
	FileList []*asset.File
}

var _ asset.WritableAsset = (*Authentication)(nil)

// Name returns a human friendly name for the asset.
func (*Authentication) Name() string {
	return "Authentication Config"
}

// Dependencies returns all of the dependencies directly needed to generate
// the asset.
func (*Authentication) Dependencies() []asset.Asset {
	return []asset.Asset{
		&installconfig.InstallConfig{},
	}
}

// Generate generates the Authentication and its CRD.
func (a *Authentication) Generate(dependencies asset.Parents) error {
	installConfig := &installconfig.InstallConfig{}
	dependencies.Get(installConfig)

	a.config = &configv1.Authentication{
		TypeMeta: metav1.TypeMeta{
			Kind:       "Authentication",
			APIVersion: configv1.GroupVersion.String(),
		},
		ObjectMeta: metav1.ObjectMeta{
			Name: "cluster",
		},
	}

	configData, err := yaml.Marshal(a.config)
	if err != nil {
		return errors.Wrapf(err, "failed to generate data for asset: %s", a.Name())
	}

	crdData, err := content.GetOpenshiftTemplate(authCrdFilename)
	if err != nil {
		return errors.Wrapf(err, "failed to get contentes of %s", authCrdFilename)
	}

	a.FileList = []*asset.File{
		{
			Filename: filepath.Join(manifestDir, authCrdFilename),
			Data:     []byte(crdData),
		},
		{
			Filename: authCfgFilename,
			Data:     configData,
		},
	}

	return nil
}

// Files returns the files generated by the asset.
func (a *Authentication) Files() []*asset.File {
	return a.FileList
}

// Load returns false since this asset is not written to disk by the installer.
func (a *Authentication) Load(f asset.FileFetcher) (bool, error) {
	return false, nil
}
