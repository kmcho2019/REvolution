module TopModule(
    input  [99:0] a,
    input  [99:0] b,
    input  sel,
    output [99:0] out
);

    // Using the conditional operator for simplicity and efficiency
    assign out = sel ? b : a;

endmodule