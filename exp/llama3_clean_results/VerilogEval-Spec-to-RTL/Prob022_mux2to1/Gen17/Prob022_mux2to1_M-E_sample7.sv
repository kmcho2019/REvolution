// Module declaration for a 2-to-1 multiplexer using basic logic gates
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    input  sel, // Select input
    output out  // Output
);

// Internal wires for the NOT of sel
wire not_sel;

// Implement NOT gate for sel
assign not_sel = ~sel;

// Implement the 2-to-1 multiplexer using AND, OR, and NOT gates
assign out = (a & not_sel) | (b & sel);

endmodule