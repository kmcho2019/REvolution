module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

// Internal wires for the AND-OR logic implementation
wire a_and_not_sel;
wire b_and_sel;

// Implement the 2-to-1 multiplexer using AND, OR, and NOT gates
assign a_and_not_sel = a & ~sel;
assign b_and_sel = b & sel;
assign out = a_and_not_sel | b_and_sel;

endmodule