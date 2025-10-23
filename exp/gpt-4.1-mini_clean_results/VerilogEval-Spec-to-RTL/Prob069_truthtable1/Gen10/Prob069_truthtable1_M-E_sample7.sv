module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);

    // Combinational logic expression derived from truth table
    assign f = (x2 & ~x3) | (x1 & (x3 ^ x2));

endmodule