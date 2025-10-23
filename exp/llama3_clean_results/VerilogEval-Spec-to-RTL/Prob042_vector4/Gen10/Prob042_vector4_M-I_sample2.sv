module TopModule (
    input [7:0] in,
    output [31:0] out
);

// Directly assign the replicated MSB and the input to the output
// Using the same replication and concatenation approach
assign out = { {24{in[7]}}, in };

endmodule