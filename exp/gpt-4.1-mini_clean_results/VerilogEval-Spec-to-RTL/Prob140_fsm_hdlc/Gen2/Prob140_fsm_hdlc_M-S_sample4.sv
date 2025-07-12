module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State counts consecutive ones: 0..6
    reg [2:0] state, next_state;

    // Latches to hold disc and flag outputs for one cycle after detection
    reg disc_latch, flag_latch;

    // Next state logic
    always @(*) begin
        if (in == 1'b0)
            next_state = 3'd0;
        else if (state < 6)
            next_state = state + 3'd1;
        else
            next_state = 3'd6; // saturate at 6
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
            disc_latch <= 1'b0;
            flag_latch <= 1'b0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            state <= next_state;

            // err: immediately asserted when 7 or more ones (state 6 and in=1)
            err <= (state == 3'd6 && in == 1'b1);

            // Latch disc if zero input when in state 5 (means detected 5 ones then zero)
            // Latch flag if zero input when in state 6 (means detected 6 ones then zero)
            disc_latch <= (state == 3'd5 && in == 1'b0);
            flag_latch <= (state == 3'd6 && in == 1'b0);

            // disc and flag asserted for exactly one cycle using latches
            disc <= disc_latch;
            flag <= flag_latch;
        end
    end

endmodule