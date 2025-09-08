<?php
namespace Grav\Theme;

use Grav\Common\Grav;
use Grav\Common\Theme;

class Basis extends Theme
{
    public static function getSubscribedEvents()
    {
        return [
            'onThemeInitialized'    => ['onThemeInitialized', 0],
            // 'onTwigLoader'          => ['onTwigLoader', 0],
            'onTwigInitialized'     => ['onTwigInitialized', 0],
        ];
    }

    public function onThemeInitialized()
    {
        // Don't proceed if we are in the admin plugin
        if ($this->isAdmin()) {
            return;
        }

    }

    // // Add images to twig template paths to allow inclusion of SVG files
    // public function onTwigLoader()
    // {
    //     $theme_paths = Grav::instance()['locator']->findResources('user://pages/01.grid');
    //     foreach($theme_paths as $images_path) {
    //         $this->grav['twig']->addPath($images_path, 'images');
    //     }
    // }

    public function onTwigInitialized() {
        if ($this->isAdmin()) {
            return;
        }

        // $function = new \Twig_SimpleFunction ("include_svg", function ($url) {
        //     $path = $this->grav["locator"]->findResources("$url");
        //     return file_get_contents($path[0]);
        // });
        // $this->grav['twig']->twig->addFunction($function);                   

        // $this->grav['twig']->twig()->addFilter(
        //     new \Twig_SimpleFilter('file_contents', [$this, 'myFileContents'])
        // );

        $this->grav['twig']->twig()->addFunction(
            new \Twig_SimpleFunction('file_contents', [$this, 'myFileContents'])
        );
    }

    public function myFileContents($file) {
        return file_get_contents($file);
    }
}
