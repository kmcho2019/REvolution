module TopModule (
    input  clk,
    input  x,
    output z
);

    reg q_xor, q_and, q_or;
    reg [3:0] reset_cnt = 4'd0;   // 4-bit counter for reset duration
    reg reset_n;

    // Generate an internal reset_n signal: active low reset asserted for 8 cycles after power-on
    always @(posedge clk) begin
        if (reset_cnt != 4'd8) begin
            reset_cnt <= reset_cnt + 1;
            reset_n <= 1'b0; // keep reset asserted while counting
        end else begin
            reset_n <= 1'b1; // de-assert reset after 8 cycles
        end
    end

    // Flip-flops with synchronous reset (active low)
    always @(posedge clk) begin
        if (!reset_n) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= x ^ q_xor;
            q_and <= x & (~q_and);
            q_or  <= x | (~q_or);
        end
    end

    // Output z is NOR of flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule