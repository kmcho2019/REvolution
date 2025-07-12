module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out to 0
);

// Internal signal to hold the output of the XOR operation
reg internal_out = 1'b0;

// Combinational logic for XOR operation
assign internal_out = in ^ out;

// Sequential logic for D flip-flop, update out on the rising edge of clk
always @(posedge clk) begin
    out <= internal_out; // Update out with the computed XOR result at the rising edge of clk
end

endmodule