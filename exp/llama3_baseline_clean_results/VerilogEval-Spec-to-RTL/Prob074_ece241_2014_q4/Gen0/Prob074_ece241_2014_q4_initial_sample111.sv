module TopModule(
    input clk,
    input x,
    output z
);

reg q0, q1, q2;  // outputs of the D flip-flops
wire d0, d1, d2;  // inputs of the D flip-flops
wire xnor0, xnor1, xnor2;  // outputs of the gates

// describe the behavior of the three gates
assign xnor0 = x ^ q0;
assign xnor1 = x & ~q1;
assign xnor2 = x | ~q2;

// describe the behavior of the D flip-flops
always @(posedge clk) begin
    q0 <= xnor0;
    q1 <= xnor1;
    q2 <= xnor2;
end

// describe the behavior of the three-input NOR gate
assign z = ~(xnor0 | xnor1 | xnor2);

// initialize the D flip-flops to zero
initial begin
    q0 = 0;
    q1 = 0;
    q2 = 0;
end

endmodule