module TopModule(
    input [7:0] in,
    output [31:0] out
);

// Refactored version using an always block for potential expansion or modification
always @(*) begin
    // The most significant bit (MSB) of the input is replicated 24 times and concatenated with the original 8-bit input
    out = { {24{in[7]}}, in };
end

endmodule