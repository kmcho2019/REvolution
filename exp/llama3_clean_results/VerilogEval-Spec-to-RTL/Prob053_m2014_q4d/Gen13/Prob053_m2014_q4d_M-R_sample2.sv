module TopModule(
    input clk,
    input in,
    output reg out
);

// Initialize 'out' to a default value (0) for deterministic behavior
initial out = 1'b0;

// Combinational logic: XOR of 'in' and 'out'
wire xor_out;
assign xor_out = in ^ out;

// Sequential logic: D flip-flop
always @(posedge clk) begin
    out <= xor_out;
end

endmodule