module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg q_xor, q_and, q_or;

    // Internal synchronous reset signal asserted on first clock cycle
    reg rst;

    // D input signals for flip-flops
    wire d_xor, d_and, d_or;

    // Initialize rst to 1 at simulation/power-up
    initial begin
        rst = 1'b1;
    end

    // Deassert rst after first positive clock edge
    always @(posedge clk) begin
        if (rst)
            rst <= 1'b0;
    end

    // Compute D inputs based on x and current flip-flop outputs or complements
    assign d_xor = x ^ q_xor;
    assign d_and = x & (~q_and);
    assign d_or  = x | (~q_or);

    // Flip-flops update on posedge clk with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Output z is NOR of all flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule