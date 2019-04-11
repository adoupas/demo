@extends('indigo-layout::auth2')

@section('meta_title', _p('pages.login.meta_title', 'Login') . ' // ' . config('app.name'))
@section('meta_description', _p('pages.login.meta_description', 'Awes.IO Platform Demo'))

@section('title')
    <h2>{{ _p('pages.login.headline', 'Welcome back!') }}</h2>
@endsection

@section('content')
    @include('indigo-layout::auth.login')
@endsection

@section('footer')
    {!! _p('pages.login.footer-headline', 'Don\'t have an account? <a href=":link_url">:link_name</a> ', ['link_url' => route('register'), 'link_name' => 'Sign Up']) !!}
@endsection