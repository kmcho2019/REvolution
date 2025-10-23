module TopModule(
    input clk,
    input x,
    output z
);

reg q1, q2, q3;

// XOR gate
wire xor_out;
assign xor_out = x ^ q1;

// AND gate
wire and_out;
assign and_out = x & ~q2;

// OR gate
wire or_out;
assign or_out = x | ~q3;

// D flip-flops
always @(posedge clk) begin
    q1 <= xor_out;
    q2 <= and_out;
    q3 <= or_out;
end

// NOR gate
assign z = ~(q1 | q2 | q3);

// Initialize the flip-flops to 0
initial begin
    q1 = 1'b0;
    q2 = 1'b0;
    q3 = 1'b0;
end

endmodule