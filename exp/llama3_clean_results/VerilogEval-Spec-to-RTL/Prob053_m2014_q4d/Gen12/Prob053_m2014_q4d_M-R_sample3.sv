module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out within the declaration for clarity
);

// Combinational logic to compute the XOR result
wire xor_result;
assign xor_result = in ^ out;

// Sequential logic for D flip-flop, explicitly defining the behavior
always @(posedge clk) begin
    // Update out with the computed XOR result at the rising edge of clk
    out <= xor_result;
end

endmodule