module TopModule(
    input clk,
    input in,
    output reg out
);

// Initialize out to a known value (1'b0) to avoid X's during simulation
initial out = 1'b0;

// Combinational logic: Define the XOR operation using an assign statement
wire xor_out;
assign xor_out = in ^ out;

// Sequential logic: Update out based on xor_out at the rising edge of clk
always @(posedge clk) begin
    // Update out with the value of xor_out
    out = xor_out;
end

endmodule