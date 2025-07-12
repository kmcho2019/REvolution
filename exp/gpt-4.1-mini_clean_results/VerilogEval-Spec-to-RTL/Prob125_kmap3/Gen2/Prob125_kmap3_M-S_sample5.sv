module TopModule (
    input a,
    input b,
    input c,
    input d,  // d is don't care, unused in logic
    output out
);

assign out = a | (~a & (c ^ b));

endmodule