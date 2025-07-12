module TopModule(
    input clk,
    input x,
    output z
);

reg q1 = 1'b0; // initialize q1 to 0
reg q2 = 1'b0; // initialize q2 to 0
reg q3 = 1'b0; // initialize q3 to 0

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

endmodule