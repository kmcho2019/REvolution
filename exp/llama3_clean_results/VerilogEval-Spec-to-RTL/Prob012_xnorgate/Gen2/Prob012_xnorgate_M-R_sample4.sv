module TopModule(
    input a,
    input b,
    output reg out
);

always @(*)
    out = ~(a ^ b);

endmodule