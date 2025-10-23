module TopModule #(
    parameter WIDTH = 1
) (
    input a,
    input b,
    output out
);
    assign out = ~(a | b);
endmodule