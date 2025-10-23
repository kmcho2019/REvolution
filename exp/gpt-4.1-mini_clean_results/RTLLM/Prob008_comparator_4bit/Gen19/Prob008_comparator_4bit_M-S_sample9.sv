module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire eq3 = (A[3] == B[3]);
    wire eq2 = (A[2] == B[2]);
    wire eq1 = (A[1] == B[1]);
    wire eq0 = (A[0] == B[0]);

    wire greater3 = (A[3] & ~B[3]);
    wire greater2 = (A[2] & ~B[2]);
    wire greater1 = (A[1] & ~B[1]);
    wire greater0 = (A[0] & ~B[0]);

    wire less3 = (~A[3] & B[3]);
    wire less2 = (~A[2] & B[2]);
    wire less1 = (~A[1] & B[1]);
    wire less0 = (~A[0] & B[0]);

    assign A_equal = eq3 & eq2 & eq1 & eq0;

    assign A_greater = 
          greater3
        | (eq3 & greater2)
        | (eq3 & eq2 & greater1)
        | (eq3 & eq2 & eq1 & greater0);

    assign A_less =
          less3
        | (eq3 & less2)
        | (eq3 & eq2 & less1)
        | (eq3 & eq2 & eq1 & less0);

endmodule