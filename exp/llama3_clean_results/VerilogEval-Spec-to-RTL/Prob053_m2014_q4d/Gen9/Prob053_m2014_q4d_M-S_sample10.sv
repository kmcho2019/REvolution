module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out to 0
);

reg temp; // Temporary variable to hold the result of XOR operation

// Combinational logic for XOR operation
always @(*) begin
    temp = in ^ out; // Compute the XOR result and store it in temp
end

// Sequential logic for D flip-flop, update out on the rising edge of clk
always @(posedge clk) begin
    out <= temp; // Update out with the computed XOR result at the rising edge of clk
end

endmodule