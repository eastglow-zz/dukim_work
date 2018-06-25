//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "dukim_workTestApp.h"
#include "dukim_workApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

template <>
InputParameters
validParams<dukim_workTestApp>()
{
  InputParameters params = validParams<dukim_workApp>();
  return params;
}

dukim_workTestApp::dukim_workTestApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  dukim_workApp::registerObjectDepends(_factory);
  dukim_workApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  dukim_workApp::associateSyntaxDepends(_syntax, _action_factory);
  dukim_workApp::associateSyntax(_syntax, _action_factory);

  Moose::registerExecFlags(_factory);
  ModulesApp::registerExecFlags(_factory);
  dukim_workApp::registerExecFlags(_factory);

  bool use_test_objs = getParam<bool>("allow_test_objects");
  if (use_test_objs)
  {
    dukim_workTestApp::registerObjects(_factory);
    dukim_workTestApp::associateSyntax(_syntax, _action_factory);
    dukim_workTestApp::registerExecFlags(_factory);
  }
}

dukim_workTestApp::~dukim_workTestApp() {}

void
dukim_workTestApp::registerApps()
{
  registerApp(dukim_workApp);
  registerApp(dukim_workTestApp);
}

void
dukim_workTestApp::registerObjects(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new test objects here! */
}

void
dukim_workTestApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
  /* Uncomment Syntax and ActionFactory parameters and register your new test objects here! */
}

void
dukim_workTestApp::registerExecFlags(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new execute flags here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
dukim_workTestApp__registerApps()
{
  dukim_workTestApp::registerApps();
}

// External entry point for dynamic object registration
extern "C" void
dukim_workTestApp__registerObjects(Factory & factory)
{
  dukim_workTestApp::registerObjects(factory);
}

// External entry point for dynamic syntax association
extern "C" void
dukim_workTestApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  dukim_workTestApp::associateSyntax(syntax, action_factory);
}

// External entry point for dynamic execute flag loading
extern "C" void
dukim_workTestApp__registerExecFlags(Factory & factory)
{
  dukim_workTestApp::registerExecFlags(factory);
}
