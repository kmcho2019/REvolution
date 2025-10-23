// Module: TopModule
// Description: A 2-input AND gate implemented using a multiplexer.
module TopModule(
    input  logic a,  // First input of the AND gate
    input  logic b,  // Second input of the AND gate
    output logic out  // Output of the AND gate
);

// Implement the AND gate using a 2-to-1 MUX
// The select line is driven by the logical AND of 'a' and 'b'
// When 'a' and 'b' are both 1, the select line is 1, and the output is 1 (a & b)
// When 'a' or 'b' (or both) is 0, the select line is 0, and the output is 0 (since the other input is tied to 0)
assign out = (a & b)? 1 : 0;

// Alternatively, using a traditional MUX structure
// logic sel;
// assign sel = a & b;
// assign out = (sel)? (a & b) : 0;

endmodule