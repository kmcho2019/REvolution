module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out to 0
);

// Combinational logic: Define the XOR operation
wire xor_out;
assign xor_out = in ^ out; // Compute XOR of 'in' and 'out'

// Sequential logic: Update out based on the XOR result at the rising edge of clk
always @(posedge clk) begin
    out <= xor_out; // Update out with the computed XOR result at the rising edge of clk
end

endmodule