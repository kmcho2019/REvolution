module TopModule(
    input clk,
    input in,
    output reg out
);

assign out = in ^ out; // Describe the combinational logic using assign

always @(posedge clk) begin
    out <= in ^ out; // Update the output of the flip-flop on the positive edge of the clock
end

endmodule