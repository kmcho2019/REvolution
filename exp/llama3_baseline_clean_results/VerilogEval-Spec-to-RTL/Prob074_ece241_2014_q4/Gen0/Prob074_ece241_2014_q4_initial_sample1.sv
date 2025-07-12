module TopModule (
    input  clk,
    input  x,
    output z
);

reg xor_ff, and_ff, or_ff;

// Initialize flip-flops to zero
initial begin
    xor_ff = 1'b0;
    and_ff = 1'b0;
    or_ff = 1'b0;
end

// XOR gate with feedback
wire xor_out;
assign xor_out = x ^ xor_ff;

// AND gate with feedback
wire and_out;
assign and_out = x & (~and_ff);

// OR gate with feedback
wire or_out;
assign or_out = x | (~or_ff);

// D flip-flops
always @(posedge clk) begin
    xor_ff <= xor_out;
    and_ff <= and_out;
    or_ff <= or_out;
end

// Three-input NOR gate
assign z = ~(xor_ff | and_ff | or_ff);

endmodule