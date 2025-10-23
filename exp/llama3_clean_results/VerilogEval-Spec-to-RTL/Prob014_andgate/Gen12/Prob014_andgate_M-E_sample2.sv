// Module: TopModule
// Description: A 2-input AND gate implementation using a multiplexer.
module TopModule(
    input  a,  // First input of the AND gate
    input  b,  // Second input of the AND gate
    output out  // Output of the AND gate
);

// Implement a 2-input AND gate using a multiplexer
// The MUX selects '1' (represented by the variable 'one') when both a and b are '1',
// otherwise, it selects '0' (represented by the variable 'zero').
wire zero = 1'b0;  // '0' input for the MUX
wire one  = 1'b1;  // '1' input for the MUX

// The select line of the MUX is determined by the logical AND of 'a' and 'b'.
// If either 'a' or 'b' is '0', the select line will be '0', causing the MUX to output '0'.
// If both 'a' and 'b' are '1', the select line will be '1', causing the MUX to output '1'.
assign out = (a & b)? one : zero;

endmodule