module Language.Syntactic.Analysis.Equality where



import Language.Syntactic.Syntax



-- | Equality for expressions. The difference between 'Eq' and 'ExprEq' is that
-- 'ExprEq' allows comparison of expressions with different value types. It is
-- assumed that when the types differ, the expressions also differ. The reason
-- for allowing comparison of different types is that this is convenient when
-- the types are existentially quantified.
class ExprEq expr
  where
    exprEq :: expr a -> expr b -> Bool

instance ExprEq dom => ExprEq (AST dom)
  where
    exprEq (Symbol a)  (Symbol b)  = exprEq a b
    exprEq (f1 :$: a1) (f2 :$: a2) = exprEq f1 f2 && exprEq a1 a2
    exprEq _ _ = False

instance ExprEq dom => Eq (AST dom a)
  where
    (==) = exprEq

instance (ExprEq expr1, ExprEq expr2) => ExprEq (expr1 :+: expr2)
  where
    exprEq (InjectL a) (InjectL b) = exprEq a b
    exprEq (InjectR a) (InjectR b) = exprEq a b
    exprEq _ _ = False

instance (ExprEq expr1, ExprEq expr2) => Eq ((expr1 :+: expr2) a)
  where
    (==) = exprEq
