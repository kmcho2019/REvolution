module TopModule (
    input clk,
    input x,
    output z
);

    reg q_xor, q_and, q_or;
    reg init_done;

    // Synchronous initialization signal generation
    always @(posedge clk) begin
        if (!init_done)
            init_done <= 1'b1;
    end

    always @(posedge clk) begin
        if (!init_done) begin
            // Reset all flip-flops to zero on first clock cycle
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            // Normal operation: update flip-flops with specified logic
            q_xor <= x ^ q_xor;
            q_and <= x & (~q_and);
            q_or  <= x | (~q_or);
        end
    end

    // Output is NOR of all flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule