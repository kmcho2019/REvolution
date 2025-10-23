module TopModule(
    input  a,
    input  b,
    output out
);
// Using a 2-to-1 multiplexer to implement an AND gate
// The select lines are 'a' and 'b', and the inputs to the MUX are '0' and '1'
// When both 'a' and 'b' are high, the MUX selects '1', otherwise '0'
assign out = (a && b) ? 1'b1 : 1'b0;

// Alternatively, using a more explicit MUX structure
// assign out = (a == 1'b1 && b == 1'b1) ? 1'b1 : 1'b0;

endmodule