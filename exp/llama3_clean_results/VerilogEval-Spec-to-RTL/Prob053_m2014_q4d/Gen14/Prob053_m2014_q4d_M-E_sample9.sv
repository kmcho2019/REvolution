module TopModule(
    input clk,
    input in,
    output reg out
);

// Combinational logic to compute the XOR result using the output of the D flip-flop
wire xor_result;
assign xor_result = in ^ out;

// Sequential logic for D flip-flop, updating out at the rising edge of clk
always @(posedge clk) begin
    // Update out with the computed XOR result
    out <= xor_result;
end

// Initial block to initialize out at the start of the simulation
initial begin
    out = 1'b0;
end

endmodule