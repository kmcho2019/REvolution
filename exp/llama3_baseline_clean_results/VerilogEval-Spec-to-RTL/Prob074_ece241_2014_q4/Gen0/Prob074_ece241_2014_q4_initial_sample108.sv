module TopModule(
    input clk,
    input x,
    output z
);

reg xor_ff, and_ff, or_ff;
wire xor_out, and_out, or_out;

// XOR gate
assign xor_out = x ^ xor_ff;

// AND gate
assign and_out = x & ~and_ff;

// OR gate
assign or_out = x | ~or_ff;

// D flip-flops
always @(posedge clk) begin
    xor_ff <= xor_out;
    and_ff <= and_out;
    or_ff <= or_out;
end

// NOR gate
assign z = ~(xor_ff | and_ff | or_ff);

endmodule