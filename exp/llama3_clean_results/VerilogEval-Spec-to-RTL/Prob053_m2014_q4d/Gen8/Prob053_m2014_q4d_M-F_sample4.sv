module TopModule(
    input clk,
    input in,
    output reg out
);

reg q; // Temporary signal to hold the current state of the flip-flop
initial q = 1'b0; // Initialize 'q' with a default value (0 in this case)

// Combinational logic for XOR operation
wire xor_out; // Signal to hold the output of the XOR operation
assign xor_out = in ^ q; // Calculate the XOR of 'in' and the current state 'q'

// Sequential logic for D flip-flop
always @(posedge clk) begin
    q <= xor_out; // Update q with the output of the XOR operation on the rising edge of the clock
    out <= q; // Directly assign 'out' the new value of 'q' using a non-blocking assignment
end

endmodule