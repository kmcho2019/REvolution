module TopModule(
    input clk,
    input x,
    output z
);

reg q0, q1, q2;

// XOR gate
wire xor_in = x ^ q0;

// AND gate with complemented output of flip-flop
wire and_in = x & ~q1;

// OR gate with complemented output of flip-flop
wire or_in = x | ~q2;

// NOR gate with outputs of flip-flops
assign z = ~(q0 | q1 | q2);

// D flip-flops
always @(posedge clk) begin
    q0 <= xor_in;
    q1 <= and_in;
    q2 <= or_in;
end

endmodule