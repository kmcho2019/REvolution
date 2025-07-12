module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);

// Using a multiplexer to implement the half adder
// The select lines are determined by the inputs a and b
// The inputs to the MUX are chosen such that they represent the truth table of a half adder
assign sum = (a & ~b) | (~a & b);  // Sum is 1 if either a or b is 1, but not both
assign cout = a & b;               // Carry-out is 1 if both a and b are 1

// Alternatively, using a MUX explicitly for educational purposes
// wire [1:0] mux_sel = {a, b}; // Combine a and b into a 2-bit select signal
// assign sum = (mux_sel == 2'b01) | (mux_sel == 2'b10);
// assign cout = (mux_sel == 2'b11);

endmodule