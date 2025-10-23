module TopModule(
    input clk,
    input in,
    output reg out
);

// Combinational logic: Perform XOR operation using continuous assignment
assign out_next = in ^ out;

// Sequential logic: Update out on the rising edge of clk
always @(posedge clk) begin
    out <= out_next;
end

endmodule