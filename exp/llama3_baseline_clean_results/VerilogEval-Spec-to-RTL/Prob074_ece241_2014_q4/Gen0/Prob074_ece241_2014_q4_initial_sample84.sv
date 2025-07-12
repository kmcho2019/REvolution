module TopModule(
    input clk,
    input x,
    output z
);

reg q0, q1, q2;

// Initialize flip-flops to 0
initial begin
    q0 = 0;
    q1 = 0;
    q2 = 0;
end

// D flip-flops
always @(posedge clk) begin
    q0 <= x ^ q0;
    q1 <= x & (~q1);
    q2 <= x | (~q2);
end

// NOR gate
assign z = ~(q0 | q1 | q2);

endmodule