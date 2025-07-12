module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out to 0
);

// Sequential logic: Update out based on the XOR result at the rising edge of clk
always @(posedge clk) begin
    // Combinational logic: Define the XOR operation directly within the always block
    out <= in ^ out; // Update out with the computed XOR result at the rising edge of clk
end

endmodule