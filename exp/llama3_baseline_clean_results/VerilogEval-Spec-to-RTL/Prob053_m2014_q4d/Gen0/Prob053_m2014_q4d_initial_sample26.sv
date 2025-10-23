module TopModule(
    input  clk,
    input  in,
    output reg out = 0 // Initialize out to 0
);

wire xor_out;

// XOR gate
assign xor_out = in ^ out;

// D flip-flop
always @(posedge clk) begin
    out <= xor_out;
end

endmodule