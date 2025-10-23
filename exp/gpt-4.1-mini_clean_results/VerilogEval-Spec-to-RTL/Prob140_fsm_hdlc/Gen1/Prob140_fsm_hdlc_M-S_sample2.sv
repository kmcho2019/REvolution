module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // States: count of consecutive ones 0..6
    // 0 means last input was zero (or at reset)
    reg [2:0] state, next_state;

    // Outputs disc and flag should assert one cycle after detection
    reg disc_r, flag_r;

    always @(*) begin
        // Default next state
        if (in == 1'b0)
            next_state = 3'd0;
        else begin
            if (state < 6)
                next_state = state + 3'd1;
            else
                next_state = 3'd6; // saturate at 6
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
            disc_r <= 1'b0;
            flag_r <= 1'b0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            state <= next_state;

            // err asserted immediately when 7+ ones: state==6 and in==1
            err <= (state == 3'd6 && in == 1'b1);

            // disc: assert when previously detected 5 ones then zero (state==0 and disc_r==1)
            // flag: assert when previously detected 6 ones then zero (state==0 and flag_r==1)

            disc <= disc_r;
            flag <= flag_r;

            // Update disc_r and flag_r on transitions into state 0 after specific sequences
            // Disc: detected when in previous cycle we were in state 5 and input==0 (next_state==0)
            disc_r <= (state == 3'd5 && in == 1'b0);

            // Flag: detected when in previous cycle we were in state 6 and input==0 (next_state==0)
            flag_r <= (state == 3'd6 && in == 1'b0);
        end
    end

endmodule