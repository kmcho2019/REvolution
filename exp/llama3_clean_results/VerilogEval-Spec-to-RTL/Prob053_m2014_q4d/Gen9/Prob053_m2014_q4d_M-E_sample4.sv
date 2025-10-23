module TopModule(
    input clk,
    input in,
    output reg out = 0 // Initialize out to 0
);

// Temporary signal to hold the output of the XOR gate
wire xor_out;

// Combinational logic: XOR gate
assign xor_out = in ^ out;

// Sequential logic: D flip-flop
always @(posedge clk) begin
    out <= xor_out;
end

endmodule