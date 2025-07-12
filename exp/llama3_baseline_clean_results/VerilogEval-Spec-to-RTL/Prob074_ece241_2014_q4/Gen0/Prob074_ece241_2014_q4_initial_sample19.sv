module TopModule(
    input clk,
    input x,
    output z
);

reg xor_ff, and_ff, or_ff;
wire xor_out, and_out, or_out;

// XOR gate with x and xor_ff output as inputs
assign xor_out = x ^ xor_ff;

// AND gate with x and the complement of and_ff as inputs
assign and_out = x & ~and_ff;

// OR gate with x and the complement of or_ff as inputs
assign or_out = x | ~or_ff;

// D flip-flops with clock input clk
always @(posedge clk) begin
    xor_ff <= xor_out;
    and_ff <= and_out;
    or_ff <= or_out;
end

// Three-input NOR gate with xor_ff, and_ff, and or_ff as inputs
assign z = ~(xor_ff | and_ff | or_ff);

// Initial values of the flip-flops
initial begin
    xor_ff = 1'b0;
    and_ff = 1'b0;
    or_ff = 1'b0;
end

endmodule