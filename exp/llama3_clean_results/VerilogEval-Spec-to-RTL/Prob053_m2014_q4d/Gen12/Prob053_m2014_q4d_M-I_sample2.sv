module TopModule(
    input clk,
    input in,
    output reg out
);

reg xor_result;

// Combinational logic: Perform XOR operation
always @(*) begin
    xor_result = in ^ out;
end

// Sequential logic: Update out on the rising edge of clk
always @(posedge clk) begin
    out <= xor_result;
end

endmodule