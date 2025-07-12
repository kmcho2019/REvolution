module TopModule(
    input clk,
    input x,
    output z
);

// Define the internal signals
reg xor_ff, and_ff, or_ff;
reg xor_out, and_out, or_out;

// Define the three two-input gates
assign xor_out = x ^ xor_ff;
assign and_out = x & (~and_ff);
assign or_out = x | (~or_ff);

// Define the three D flip-flops
always @(posedge clk) begin
    xor_ff <= xor_out;
    and_ff <= and_out;
    or_ff <= or_out;
end

// Initialize the flip-flops to zero
initial begin
    xor_ff <= 1'b0;
    and_ff <= 1'b0;
    or_ff <= 1'b0;
end

// Define the three-input NOR gate
assign z = ~(xor_ff | and_ff | or_ff);

endmodule