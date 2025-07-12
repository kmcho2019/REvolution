module TopModule(
    input [99:0] a, // input a is 100 bits wide
    input [99:0] b, // input b is 100 bits wide
    input sel,
    output [99:0] out // output out is 100 bits wide
);

    assign out = sel ? b : a; // Use ternary operator to choose between a and b based on sel

endmodule