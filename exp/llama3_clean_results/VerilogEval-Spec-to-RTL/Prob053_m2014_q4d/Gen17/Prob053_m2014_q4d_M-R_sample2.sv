module TopModule(
    input clk,
    input in,
    output out
);

reg q;  // Internal register to hold the flip-flop's state

// Combinatorial logic: XOR operation using assign statement
assign out = q ^ in;

// Sequential logic: D flip-flop
always @(posedge clk) begin
    q <= out;  // Update the internal state 'q' with the 'out' value
end

// Initialize 'q' to a default value (0) for deterministic behavior
initial begin
    q = 1'b0;
end

endmodule