//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#ifndef DUKIM_WORKAPP_H
#define DUKIM_WORKAPP_H

#include "MooseApp.h"

class dukim_workApp;

template <>
InputParameters validParams<dukim_workApp>();

class dukim_workApp : public MooseApp
{
public:
  dukim_workApp(InputParameters parameters);
  virtual ~dukim_workApp();

  static void registerApps();
  static void registerObjects(Factory & factory);
  static void registerObjectDepends(Factory & factory);
  static void associateSyntax(Syntax & syntax, ActionFactory & action_factory);
  static void associateSyntaxDepends(Syntax & syntax, ActionFactory & action_factory);
  static void registerExecFlags(Factory & factory);
};

#endif /* DUKIM_WORKAPP_H */
