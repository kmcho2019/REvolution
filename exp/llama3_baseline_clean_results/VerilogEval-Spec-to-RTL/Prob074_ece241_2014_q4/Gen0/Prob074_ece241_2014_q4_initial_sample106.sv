module TopModule(
    input clk,
    input x,
    output z
);

reg xor_ff, and_ff, or_ff;

// XOR gate
wire xor_out;
assign xor_out = x ^ xor_ff;

// AND gate
wire and_out;
assign and_out = x & ~and_ff;

// OR gate
wire or_out;
assign or_out = x | ~or_ff;

// NOR gate
assign z = ~(xor_ff | and_ff | or_ff);

// D flip-flops
always @(posedge clk) begin
    xor_ff <= xor_out;
    and_ff <= and_out;
    or_ff <= or_out;
end

// Initial values for flip-flops
initial begin
    xor_ff = 1'b0;
    and_ff = 1'b0;
    or_ff = 1'b0;
end

endmodule