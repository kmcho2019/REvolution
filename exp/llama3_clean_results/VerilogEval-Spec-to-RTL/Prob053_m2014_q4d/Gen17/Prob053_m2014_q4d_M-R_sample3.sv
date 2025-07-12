module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out to 0
);

// Combinational logic: XOR operation between 'in' and 'out'
wire xor_out;
assign xor_out = in ^ out;

// Sequential logic: Update 'out' on the rising edge of 'clk' with 'xor_out'
always @(posedge clk) begin
    out <= xor_out;
end

endmodule