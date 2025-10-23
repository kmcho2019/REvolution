module TopModule(
    input clk,
    input x,
    output z
);

reg q_xor, q_and, q_or; // outputs of the D flip-flops
wire xor_out, and_out, or_out; // outputs of the gates

// define the outputs of the gates as functions of x and the flip-flop outputs
assign xor_out = x ^ q_xor;
assign and_out = x & ~q_and;
assign or_out = x | ~q_or;

// on the positive edge of the clock, update the D flip-flop outputs
always @(posedge clk) begin
    q_xor <= xor_out;
    q_and <= and_out;
    q_or <= or_out;
end

// use the outputs of the D flip-flops as inputs to the NOR gate to produce z
assign z = ~(q_xor | q_and | q_or);

// initialize the D flip-flops to zero
initial begin
    q_xor = 0;
    q_and = 0;
    q_or = 0;
end

endmodule