// Novel Module TopModule implementing a NOR gate using a binary decoder and inverter.
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

// Use a 2-to-1 decoder to detect when both inputs are low (NOR condition).
wire decoder_out;  // Output of the decoder
assign decoder_out = ~(a & b);  // Decoder detects when both inputs are not high

// Use an inverter to ensure the output is high when the decoder detects the NOR condition.
assign out = decoder_out;  // Directly assign decoder output to out

endmodule