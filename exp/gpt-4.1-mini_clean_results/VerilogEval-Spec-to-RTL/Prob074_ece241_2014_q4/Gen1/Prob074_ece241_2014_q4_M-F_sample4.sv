module TopModule (
    input clk,
    input reset_n, // Active low asynchronous reset input
    input x,
    output z
);

    reg Q0, Q1, Q2;
    wire D0, D1, D2;

    // Compute D inputs based on current flip-flop outputs and input x
    assign D0 = x ^ Q0;      // XOR with Q0
    assign D1 = x & (~Q1);   // AND with complement of Q1
    assign D2 = x | (~Q2);   // OR with complement of Q2

    // Flip-flops update on posedge clk or asynchronous reset (active low)
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            Q0 <= 1'b0;
            Q1 <= 1'b0;
            Q2 <= 1'b0;
        end else begin
            Q0 <= D0;
            Q1 <= D1;
            Q2 <= D2;
        end
    end

    // Output is NOR of the three flip-flop outputs
    assign z = ~(Q0 | Q1 | Q2);

endmodule