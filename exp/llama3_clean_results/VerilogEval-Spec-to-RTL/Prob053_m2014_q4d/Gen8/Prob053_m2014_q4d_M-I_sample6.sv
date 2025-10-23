module TopModule(
    input clk,
    input in,
    output reg out
);

// Initialize out to a known state (0) to avoid unpredictable behavior due to the feedback loop
initial out = 0;

// Combinational logic for XOR operation
wire xor_out;
assign xor_out = in ^ out;

// Sequential logic for D flip-flop
always @(posedge clk) begin
    out <= xor_out; // Update out with the output of the XOR operation on the rising edge of the clock
end

endmodule