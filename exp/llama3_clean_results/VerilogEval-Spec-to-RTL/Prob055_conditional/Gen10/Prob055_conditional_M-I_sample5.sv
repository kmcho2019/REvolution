module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Use wires for intermediate results to potentially improve readability and synthesis
    wire [7:0] min_ab;
    wire [7:0] min_cd;

    // First layer of comparison
    assign min_ab = (a < b)? a : b;
    assign min_cd = (c < d)? c : d;

    // Final comparison to find the minimum
    // Using a ternary operator for simplicity and clarity
    assign min = (min_ab < min_cd)? min_ab : min_cd;

    // Note: Explicit MUX logic could be used for educational purposes or specific optimization needs
    // assign min = ({8{min_ab < min_cd}}? min_ab : min_cd);

endmodule