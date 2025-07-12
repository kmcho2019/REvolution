module TopModule(
    input clk,
    input in,
    output reg out
);

// Initialize out using an initial block
initial begin
    out = 1'b0; // Explicitly set out to 0 at the start of simulation
end

// Temporary signal to hold the feedback value
reg feedback;

// Combinational logic to compute the XOR result
wire xor_result;
assign xor_result = in ^ out;

// Sequential logic for D flip-flop, update out on the rising edge of clk
always @(posedge clk) begin
    feedback <= out; // Update feedback with the current out value
    out <= xor_result; // Update out with the computed XOR result
end

endmodule