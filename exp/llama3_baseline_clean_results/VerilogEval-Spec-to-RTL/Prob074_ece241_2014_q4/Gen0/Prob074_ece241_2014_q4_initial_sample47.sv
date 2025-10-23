module TopModule(
    input  clk,
    input  x,
    output z
);

reg q0, q1, q2;
wire xor_out, and_out, or_out;

// Define the outputs of the gates
assign xor_out = x ^ q0;
assign and_out = x & ~q1;
assign or_out = x | ~q2;

// Define the D flip-flops
always @(posedge clk) begin
    q0 <= xor_out;
    q1 <= and_out;
    q2 <= or_out;
end

// Define the output z
assign z = ~(q0 | q1 | q2);

// Initialize the flip-flops to zero
initial begin
    q0 = 0;
    q1 = 0;
    q2 = 0;
end

endmodule