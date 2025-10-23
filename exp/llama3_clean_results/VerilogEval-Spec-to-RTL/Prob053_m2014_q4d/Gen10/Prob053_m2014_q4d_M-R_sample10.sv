module TopModule(
    input clk,
    input in,
    output reg out
);

// Continuous assignment for the XOR gate output
wire xor_out;
assign xor_out = in ^ out;

// Simple always block for the flip-flop's state update on posedge clk
always @(posedge clk) begin
    out <= xor_out;
end

endmodule