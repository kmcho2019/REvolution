module TopModule(
    input  clk,
    input  x,
    output z
);

reg q0, q1, q2; // Outputs of the D flip-flops

// XOR, AND, and OR operations
wire xor_out = x ^ q0;
wire and_out = x & ~q1;
wire or_out = x | ~q2;

// D flip-flops
always @(posedge clk) begin
    q0 <= xor_out;
    q1 <= and_out;
    q2 <= or_out;
end

// NOR gate
assign z = ~(q0 | q1 | q2);

initial begin
    q0 = 0;
    q1 = 0;
    q2 = 0;
end

endmodule