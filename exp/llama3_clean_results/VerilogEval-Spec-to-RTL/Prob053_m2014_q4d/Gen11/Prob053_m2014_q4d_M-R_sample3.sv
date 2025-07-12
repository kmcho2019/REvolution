module TopModule(
    input clk,
    input in,
    output reg out
);

// Initialize out to 0 to ensure a defined starting state
initial out = 1'b0;

// Combinational logic to compute the XOR result
wire xor_result;
assign xor_result = in ^ out;

// Sequential logic for D flip-flop, update out on the rising edge of clk
always @(posedge clk) begin
    out <= xor_result; // Update out with the computed XOR result at the rising edge of clk
end

endmodule