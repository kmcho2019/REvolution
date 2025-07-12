module TopModule(
    input a,
    input b,
    output reg q
);

always @(*)
    q = a & b;

endmodule