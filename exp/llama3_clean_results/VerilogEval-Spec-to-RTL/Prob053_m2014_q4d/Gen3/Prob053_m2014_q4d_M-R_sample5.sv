module TopModule(
    input clk,
    input in,
    output reg out
);

// Use an assign statement to implement the XOR gate
wire xor_out;
assign xor_out = in ^ out;

// Use an always block to implement the D flip-flop
always @(posedge clk) begin
    // Use the output of the XOR gate as the input to the D flip-flop
    out <= xor_out;
end

endmodule