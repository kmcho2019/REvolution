module TopModule(
    input  [99:0] a,
    input  [99:0] b,
    input  sel,
    output [99:0] out
);
    // Maintain the efficient conditional operator for simplicity and performance
    assign out = sel? b : a;
endmodule