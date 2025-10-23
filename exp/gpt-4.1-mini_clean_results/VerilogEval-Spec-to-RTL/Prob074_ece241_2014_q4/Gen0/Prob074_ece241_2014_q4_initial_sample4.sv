module TopModule (
    input clk,
    input x,
    output z
);

    reg Q0, Q1, Q2;
    wire D0, D1, D2;

    // Initial reset of flip-flops to zero
    initial begin
        Q0 = 1'b0;
        Q1 = 1'b0;
        Q2 = 1'b0;
    end

    // Compute D inputs
    assign D0 = x ^ Q0;      // XOR with Q0
    assign D1 = x & (~Q1);   // AND with complement of Q1
    assign D2 = x | (~Q2);   // OR with complement of Q2

    // Flip-flops update on posedge clk
    always @(posedge clk) begin
        Q0 <= D0;
        Q1 <= D1;
        Q2 <= D2;
    end

    // Output is NOR of the three flip-flop outputs
    assign z = ~(Q0 | Q1 | Q2);

endmodule