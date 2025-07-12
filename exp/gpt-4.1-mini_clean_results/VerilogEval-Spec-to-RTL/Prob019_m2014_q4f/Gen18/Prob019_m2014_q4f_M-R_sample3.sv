module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    wire not_in2;

    // Invert in2 using continuous assignment directly
    assign not_in2 = ~in2;

    // AND in1 with inverted in2 using continuous assignment
    assign out = in1 & not_in2;

endmodule