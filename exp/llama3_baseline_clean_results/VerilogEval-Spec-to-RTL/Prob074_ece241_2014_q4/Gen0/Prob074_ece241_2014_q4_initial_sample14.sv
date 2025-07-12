module TopModule(
    input clk,
    input x,
    output z
);

reg q_x, q_and, q_or; // internal signals for D flip-flop outputs
wire xor_out, and_out, or_out; // internal signals for gate outputs

// define outputs of the gates
assign xor_out = x ^ q_x;
assign and_out = x & ~q_and;
assign or_out = x | ~q_or;

// define output z as the output of the NOR gate
assign z = ~(xor_out | and_out | or_out);

// update D flip-flops on the positive edge of the clock
always @(posedge clk) begin
    q_x <= xor_out;
    q_and <= and_out;
    q_or <= or_out;
end

// initialize D flip-flops to zero
initial begin
    q_x = 0;
    q_and = 0;
    q_or = 0;
end

endmodule