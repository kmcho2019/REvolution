module TopModule(
    input clk,
    input in,
    output reg out
);

// Combinational logic: XOR gate
wire xor_out = in ^ out;

// Sequential logic: D flip-flop
always @(posedge clk) begin
    out <= xor_out;
end

// Initialize the output to avoid undefined behavior
initial begin
    out = 0;
end

endmodule