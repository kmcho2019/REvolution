module TopModule (
    input  clk,
    input  x,
    output z
);

    // Internal 2-bit reset counter, generates reset for first two clock cycles
    reg [1:0] reset_cnt = 2'b00;
    wire internal_rst = (reset_cnt != 2'b11);

    // Flip-flop state registers
    reg q_xor, q_and, q_or;

    always @(posedge clk) begin
        // Increment reset counter up to 3 (de-assert reset after 2 cycles)
        if (reset_cnt != 2'b11)
            reset_cnt <= reset_cnt + 1'b1;

        if (internal_rst) begin
            // Synchronous reset: initialize all flip-flops to zero
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            // Compute next states based on current states and input x
            q_xor <= x ^ q_xor;       // XOR gate input D
            q_and <= x & (~q_and);    // AND gate input D
            q_or  <= x | (~q_or);     // OR gate input D
        end
    end

    // Output is NOR of flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule