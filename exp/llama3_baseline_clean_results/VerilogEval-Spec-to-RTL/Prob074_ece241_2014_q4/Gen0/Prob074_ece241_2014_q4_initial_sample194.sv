module TopModule(
    input clk,
    input x,
    output z
);

reg xor_ff_out, and_ff_out, or_ff_out;
wire xor_in, and_in, or_in, nor_in0, nor_in1, nor_in2;

// Create the gates
assign xor_in = xor_ff_out ^ x;
assign and_in = ~and_ff_out & x;
assign or_in = ~or_ff_out | x;

// Instantiate the D flip-flops
always @(posedge clk) begin
    xor_ff_out <= xor_in;
    and_ff_out <= and_in;
    or_ff_out <= or_in;
end

// Initialize the flip-flops to zero
initial begin
    xor_ff_out = 1'b0;
    and_ff_out = 1'b0;
    or_ff_out = 1'b0;
end

// Connect the flip-flop outputs to a three-input NOR gate
assign z = ~(xor_ff_out | and_ff_out | or_ff_out);

endmodule