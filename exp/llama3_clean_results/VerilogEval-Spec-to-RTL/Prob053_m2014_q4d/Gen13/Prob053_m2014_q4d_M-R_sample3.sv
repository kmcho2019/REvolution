module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out to 0
);

// Combinational logic: Define the XOR operation using an assign statement
wire xor_out;
assign xor_out = in ^ out;

// Sequential logic: Update out based on xor_out at the rising edge of clk
always @(posedge clk) begin
    out <= xor_out; // Update out with xor_out at the rising edge of clk
end

endmodule