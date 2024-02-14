<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class LogedController extends AbstractController
{
    #[Route('/loged', name: 'app_loged')]
    public function index(): Response
    {
        return $this->render('loged/index.html.twig', [
            'controller_name' => 'LogedController',
        ]);
    }
}
