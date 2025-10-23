module TopModule(
    input  [99:0] a,  // 100 bits
    input  [99:0] b,  // 100 bits
    input  sel,
    output [99:0] out  // 100 bits
);

assign out = sel ? b : a;

endmodule