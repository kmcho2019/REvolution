module TopModule(
    input clk,
    input in,
    output out
);

reg q;  // Internal register to hold the flip-flop's state
wire xor_out;  // Wire to hold the output of the XOR operation

// Combinatorial logic: XOR operation using assign statement
assign xor_out = in ^ out;

// Sequential logic: D flip-flop
always @(posedge clk) begin
    q <= xor_out;  // Update the internal state 'q' with the XOR operation's result
end

// Assign the output of the flip-flop to 'out'
assign out = q;

// Initialize 'q' to a default value (0) for deterministic behavior
initial begin
    q = 1'b0;
end

endmodule