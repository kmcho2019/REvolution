module TopModule(
    input clk,
    input in,
    output reg out
);

// Initialize out to avoid undefined behavior during the first clock cycle
initial out = 1'b0;

// Define a separate variable for the XOR gate's output to break the feedback loop
reg xor_out;

// Combinational logic for XOR operation
always @(*) begin
    // Compute xor_out based on the current value of out
    xor_out = in ^ out;
end

// Sequential logic for D flip-flop, update out on the rising edge of clk
always @(posedge clk) begin
    // Update out with the computed XOR result at the rising edge of clk
    out <= xor_out;
end

endmodule