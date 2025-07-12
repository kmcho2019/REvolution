module TopModule (
    input clk,
    input x,
    output z
);

    // Internal synchronous reset generation (one cycle after power-on)
    reg reset_done = 1'b0;

    // Flip-flop state registers
    reg q_xor, q_and, q_or;

    // On first clock edge, release reset; before that reset is active
    always @(posedge clk) begin
        if (!reset_done)
            reset_done <= 1'b1;
    end

    // D input signals
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Flip-flops with synchronous reset
    always @(posedge clk) begin
        if (!reset_done) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Output z is the NOR of the flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule