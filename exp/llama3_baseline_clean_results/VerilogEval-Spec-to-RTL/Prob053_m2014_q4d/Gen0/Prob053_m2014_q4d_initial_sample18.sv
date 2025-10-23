module TopModule(
    input  clk,
    input  in,
    output out
);

reg out_reg; // Register to hold the output of the DFF
assign out = out_reg; // Continuous assignment to drive the output

// XOR gate
wire xor_out;
assign xor_out = in ^ out;

// D flip-flop
always @ (posedge clk) begin
    out_reg <= xor_out; // On positive edge of clk, capture the XOR output
end

// Initialize the output register to avoid undefined behavior
initial begin
    out_reg = 1'b0; // Initialize out_reg to 0
end

endmodule