module TopModule(
    input clk,
    input x,
    output z
);

reg q0, q1, q2; // outputs of the D flip-flops

// Gates' outputs
wire xor_out, and_out, or_out;

// Assign gates' outputs
assign xor_out = x ^ q0;
assign and_out = x & ~q1;
assign or_out = x | ~q2;

// D flip-flops
always @(posedge clk) begin
    q0 <= xor_out;
    q1 <= and_out;
    q2 <= or_out;
end

// NOR gate
assign z = ~(xor_out | and_out | or_out);

// Initial values of the flip-flops
initial begin
    q0 = 1'b0;
    q1 = 1'b0;
    q2 = 1'b0;
end

endmodule