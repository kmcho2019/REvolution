module TopModule (
    input  clk,
    input  x,
    output z
);

    reg q_xor, q_and, q_or;
    reg reset_n; // internal synchronous reset flag

    initial begin
        // Start with reset asserted
        reset_n = 1'b0;
    end

    always @(posedge clk) begin
        if (!reset_n) begin
            // On first clock, initialize flip-flops to zero and release reset
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
            reset_n <= 1'b1;  // release reset after initialization
        end else begin
            q_xor <= x ^ q_xor;
            q_and <= x & (~q_and);
            q_or  <= x | (~q_or);
        end
    end

    assign z = ~(q_xor | q_and | q_or);

endmodule