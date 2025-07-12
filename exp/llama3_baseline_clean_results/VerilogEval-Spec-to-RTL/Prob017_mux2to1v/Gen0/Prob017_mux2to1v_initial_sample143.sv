module TopModule(
    input  [99:0] a,  // input a (100 bits)
    input  [99:0] b,  // input b (100 bits)
    input         sel,  // select input
    output [99:0] out  // output (100 bits)
);

assign out = sel ? b : a;

endmodule