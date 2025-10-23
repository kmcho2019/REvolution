module TopModule(
    input clk,
    input x,
    output z
);

reg xor_ff, and_ff, or_ff; // D flip-flop outputs

// Complemented flip-flop outputs
wire xor_ff_bar, and_ff_bar, or_ff_bar;

// Gate outputs
wire xor_out, and_out, or_out;

// Compute complemented flip-flop outputs
assign xor_ff_bar = ~xor_ff;
assign and_ff_bar = ~and_ff;
assign or_ff_bar = ~or_ff;

// Two-input gate logic
assign xor_out = x ^ xor_ff;
assign and_out = x & and_ff_bar;
assign or_out = x | or_ff_bar;

// Sequential logic: D flip-flops
always @(posedge clk) begin
    xor_ff <= xor_out;
    and_ff <= and_out;
    or_ff <= or_out;
end

// Three-input NOR gate for output z
assign z = ~(xor_ff | and_ff | or_ff);

endmodule