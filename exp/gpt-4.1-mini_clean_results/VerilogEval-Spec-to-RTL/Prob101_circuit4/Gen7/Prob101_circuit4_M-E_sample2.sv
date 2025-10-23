module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,    // d is unused
    output wire q
);

wire bc_or;
wire a_not;
wire select;

assign bc_or = b | c;
assign a_not = ~a;
assign select = a_not | a;  // Always 1, but for demonstration.

assign q = bc_or & select; // Simplifies to q = b | c

endmodule