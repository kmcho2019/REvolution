module TopModule (
    input a,
    input b,
    input c,
    input d,  // d is don't-care and not used
    output out
);

assign out = a | (~a & (b ^ c));

endmodule