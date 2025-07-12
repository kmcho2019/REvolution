module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // FSM states: IDLE (no ones), DISC_OUT, FLAG_OUT, ERR_OUT
    localparam IDLE     = 2'd0;
    localparam DISC_OUT = 2'd1;
    localparam FLAG_OUT = 2'd2;
    localparam ERR_OUT  = 2'd3;

    reg [1:0] curr_state, nxt_state;
    reg [2:0] count_ones, nxt_count_ones;

    // Next state and count logic
    always @(*) begin
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;

        nxt_state = curr_state;
        nxt_count_ones = count_ones;

        case (curr_state)
            IDLE: begin
                if (in) begin
                    // Start counting ones
                    nxt_count_ones = 3'd1;
                    nxt_state = IDLE;
                end else begin
                    // Stay idle, count zero
                    nxt_count_ones = 3'd0;
                    nxt_state = IDLE;
                end
            end

            DISC_OUT: begin
                disc = 1'b1;
                // After asserting disc one cycle, determine next count and state based on input
                if (in) begin
                    nxt_count_ones = 3'd1;
                    nxt_state = IDLE;
                end else begin
                    nxt_count_ones = 3'd0;
                    nxt_state = IDLE;
                end
            end

            FLAG_OUT: begin
                flag = 1'b1;
                // After flag asserted one cycle, reset count according to input
                if (in) begin
                    nxt_count_ones = 3'd1;
                    nxt_state = IDLE;
                end else begin
                    nxt_count_ones = 3'd0;
                    nxt_state = IDLE;
                end
            end

            ERR_OUT: begin
                err = 1'b1;
                if (in) begin
                    // Stay in error state while input is 1
                    nxt_count_ones = 3'd7; // stuck at 7+
                    nxt_state = ERR_OUT;
                end else begin
                    // Reset error on zero input
                    nxt_count_ones = 3'd0;
                    nxt_state = IDLE;
                end
            end

            default: begin
                // Default safe reset
                nxt_state = IDLE;
                nxt_count_ones = 3'd0;
            end
        endcase

        // Only proceed counting ones if in IDLE state (normal counting)
        if (curr_state == IDLE) begin
            if (in) begin
                // Increment count but saturate at 7 (7 or more)
                if (count_ones < 3'd7)
                    nxt_count_ones = count_ones + 3'd1;
                else
                    nxt_count_ones = 3'd7;

                // Check if count reached special values triggering transitions
                if (count_ones == 3'd5) begin
                    // After 5 ones, if next bit is 0 (checked below), discard zero next cycle
                    // But input is 1 here, so stay counting
                    // Wait for zero to trigger discard
                    nxt_state = IDLE;
                end else if (count_ones == 3'd6) begin
                    // After 6 ones, if next bit is 0, flag next cycle
                    // Input still 1 here, so continue counting
                    nxt_state = IDLE;
                end else if (count_ones >= 3'd7) begin
                    // Error detected at count 7 (or more)
                    nxt_state = ERR_OUT;
                end else begin
                    nxt_state = IDLE;
                end
            end else begin
                // Input zero after some ones
                // Decide on disc, flag or reset count
                if (count_ones == 3'd5) begin
                    // 0111110 pattern detected - discard zero next cycle
                    nxt_state = DISC_OUT;
                    nxt_count_ones = 3'd0;
                end else if (count_ones == 3'd6) begin
                    // 01111110 pattern detected - flag next cycle
                    nxt_state = FLAG_OUT;
                    nxt_count_ones = 3'd0;
                end else if (count_ones >= 3'd7) begin
                    // Seven or more ones ended by zero => still error (assert err one cycle)
                    // But err must be asserted immediately after seventh one,
                    // so better to go ERR_OUT directly already on 7th one
                    // Here we just go to IDLE since error already detected on counting step
                    nxt_state = ERR_OUT;
                    nxt_count_ones = 3'd0; // clear count on zero input after err_out?
                end else begin
                    // Zero input, no special pattern, reset count to zero
                    nxt_state = IDLE;
                    nxt_count_ones = 3'd0;
                end
            end
        end

    end

    // State and count registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            curr_state <= IDLE;
            count_ones <= 3'd0;
        end else begin
            curr_state <= nxt_state;
            count_ones <= nxt_count_ones;
        end
    end

endmodule