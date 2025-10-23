module TopModule(
    input clk,
    input x,
    output z
);

reg xor_out, and_out, or_out;
reg xor_ff, and_ff, or_ff;

// XOR gate
assign xor_out = x ^ xor_ff;

// AND gate
assign and_out = x & ~and_ff;

// OR gate
assign or_out = x | ~or_ff;

// NOR gate
assign z = ~(xor_ff | and_ff | or_ff);

// D flip-flops
always @(posedge clk) begin
    xor_ff <= xor_out;
    and_ff <= and_out;
    or_ff <= or_out;
end

// Initial values for the flip-flops
initial begin
    xor_ff = 0;
    and_ff = 0;
    or_ff = 0;
end

endmodule