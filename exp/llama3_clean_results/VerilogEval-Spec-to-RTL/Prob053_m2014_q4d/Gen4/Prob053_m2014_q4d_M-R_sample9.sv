module TopModule(
    input clk,
    input in,
    output reg out
);

// Combinational logic for XOR operation using continuous assignment
wire d;
assign d = in ^ out;

// Sequential logic for D flip-flop
always @(posedge clk) begin
    out <= d;
end

endmodule