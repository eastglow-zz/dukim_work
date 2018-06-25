#include "dukim_workApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

template <>
InputParameters
validParams<dukim_workApp>()
{
  InputParameters params = validParams<MooseApp>();
  return params;
}

dukim_workApp::dukim_workApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  dukim_workApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  dukim_workApp::associateSyntax(_syntax, _action_factory);

  Moose::registerExecFlags(_factory);
  ModulesApp::registerExecFlags(_factory);
  dukim_workApp::registerExecFlags(_factory);
}

dukim_workApp::~dukim_workApp() {}

void
dukim_workApp::registerApps()
{
  registerApp(dukim_workApp);
}

void
dukim_workApp::registerObjects(Factory & factory)
{
    Registry::registerObjectsTo(factory, {"dukim_workApp"});
}

void
dukim_workApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & action_factory)
{
  Registry::registerActionsTo(action_factory, {"dukim_workApp"});

  /* Uncomment Syntax parameter and register your new production objects here! */
}

void
dukim_workApp::registerObjectDepends(Factory & /*factory*/)
{
}

void
dukim_workApp::associateSyntaxDepends(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
}

void
dukim_workApp::registerExecFlags(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new execution flags here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
dukim_workApp__registerApps()
{
  dukim_workApp::registerApps();
}

extern "C" void
dukim_workApp__registerObjects(Factory & factory)
{
  dukim_workApp::registerObjects(factory);
}

extern "C" void
dukim_workApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  dukim_workApp::associateSyntax(syntax, action_factory);
}

extern "C" void
dukim_workApp__registerExecFlags(Factory & factory)
{
  dukim_workApp::registerExecFlags(factory);
}
