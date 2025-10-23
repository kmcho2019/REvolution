module TopModule(
    input clk,
    input in,
    output reg out
);

wire next_out; // Wire to hold the next state of out

assign next_out = in ^ out; // Continuous assignment for combinational logic

always @(posedge clk) begin
    // Update out with next_out at the positive edge of clk
    out <= next_out;
end

endmodule