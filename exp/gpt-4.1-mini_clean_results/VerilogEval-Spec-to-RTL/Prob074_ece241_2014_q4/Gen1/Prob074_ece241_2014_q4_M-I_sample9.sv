module TopModule (
    input  clk,
    input  x,
    output z
);
    reg q_xor, q_and, q_or;
    reg init_reset;  // Internal synchronous reset

    // On first clock, clear flip-flops and then de-assert reset
    always @(posedge clk) begin
        if (init_reset) begin
            q_xor <= 0;
            q_and <= 0;
            q_or  <= 0;
            init_reset <= 0;  // De-assert after first reset
        end else begin
            q_xor <= x ^ q_xor;
            q_and <= x & (~q_and);
            q_or  <= x | (~q_or);
        end
    end

    // Initialize init_reset to 1 at start (for simulation and synthesis)
    initial begin
        init_reset = 1;
    end

    assign z = ~(q_xor | q_and | q_or);

endmodule