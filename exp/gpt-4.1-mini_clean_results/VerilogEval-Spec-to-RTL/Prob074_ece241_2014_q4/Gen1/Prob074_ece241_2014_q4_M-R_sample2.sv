module TopModule (
    input clk,
    input x,
    output z
);

    reg q_xor, q_and, q_or;

    // Power-on reset counter and reset signal
    reg [2:0] reset_cnt = 3'd0;
    wire reset;

    assign reset = (reset_cnt != 3'd7);

    always @(posedge clk) begin
        if (reset_cnt != 3'd7)
            reset_cnt <= reset_cnt + 1'b1;
    end

    always @(posedge clk) begin
        if (reset) begin
            // synchronous reset: initialize all flip-flops to 0
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            // Compute next state for each flip-flop
            q_xor <= x ^ q_xor;
            q_and <= x & (~q_and);
            q_or  <= x | (~q_or);
        end
    end

    // Output z is NOR of flip-flops outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule