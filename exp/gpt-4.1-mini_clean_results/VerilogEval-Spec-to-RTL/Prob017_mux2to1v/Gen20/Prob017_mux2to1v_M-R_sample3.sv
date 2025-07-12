module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Use a single continuous assignment with ternary operator to select between a and b.
    assign out = sel ? b : a;
endmodule