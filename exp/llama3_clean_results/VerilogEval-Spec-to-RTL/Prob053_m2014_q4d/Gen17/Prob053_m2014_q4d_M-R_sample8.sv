module TopModule(
    input clk,
    input in,
    output reg out = 1'b0
);

// Combinational logic for XOR operation
wire xout;
assign xout = in ^ out;

// Sequential logic for D flip-flop
always @(posedge clk) begin
    // Update out with the result of the XOR operation at the rising edge of clk
    out <= xout;
end

endmodule