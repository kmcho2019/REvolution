module TopModule(
    input clk,
    input in,
    output reg out
);

// Combinational logic for XOR operation using continuous assignment
assign out = in ^ out;

// This does not work because out is used in the assign statement.

// Instead, we can do the following:
reg internal_out;
assign internal_out = in ^ out;

// Sequential logic for D flip-flop
always @(posedge clk) begin
    out <= internal_out;
end

endmodule