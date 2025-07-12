module TopModule(
    input clk,
    input in,
    output reg out
);

reg xor_out;

// Combinational logic for XOR operation
always @(*) begin
    xor_out = in ^ out;
end

// Sequential logic for D flip-flop
always @(posedge clk) begin
    out <= xor_out;
end

endmodule