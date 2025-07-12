module TopModule(
    input clk,
    input in,
    output reg out
);

reg internal_out; // Holds the previous state (output) of the flip-flop

always @(posedge clk) begin
    // Compute the output of the XOR gate based on 'in' and the previous 'out'
    reg xor_output = in ^ internal_out;
    // Update the internal_out (previous state of the flip-flop) with the new value
    internal_out <= xor_output;
end

// Continuous assignment for out, to always reflect the current internal_out
assign out = internal_out;

endmodule