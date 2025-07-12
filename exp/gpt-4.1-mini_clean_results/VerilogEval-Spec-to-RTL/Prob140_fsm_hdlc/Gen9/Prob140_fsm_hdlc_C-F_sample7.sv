module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // FSM states for output signaling (Moore output states)
    localparam STATE_COUNT = 2'd0; // Counting consecutive ones
    localparam STATE_DISC  = 2'd1; // Output disc pulse
    localparam STATE_FLAG  = 2'd2; // Output flag pulse
    localparam STATE_ERR   = 2'd3; // Output error pulse (sticky)

    reg [1:0] state, next_state;

    // Counter of consecutive ones, saturated at 7 (3 bits)
    reg [2:0] counter, next_counter;

    // Calculate next_counter: counts consecutive ones, saturates at 7
    // Reset to 0 on zero input
    wire [2:0] incr_counter = (counter < 3'd7) ? (counter + 3'd1) : 3'd7;

    always @(*) begin
        // Default assignments
        next_counter = counter;
        next_state = state;

        case(state)
            STATE_COUNT: begin
                if (in) begin
                    next_counter = incr_counter;
                end else begin
                    next_counter = 3'd0;
                end

                // Check detection conditions after counting the input bit
                // Conditions are based on current counter before next input or on next_counter?

                // We want outputs asserted on the cycle after detection.
                // Detection conditions come from previous cycle's counter & current input.
                // Because input affects next_counter, use current counter and input to detect.

                if ((counter == 3'd5) && (in == 1'b0)) // 0111110 pattern -> disc output
                    next_state = STATE_DISC;
                else if ((counter == 3'd6) && (in == 1'b0)) // 01111110 pattern -> flag output
                    next_state = STATE_FLAG;
                else if ((next_counter == 3'd7) && in) // 7 or more consecutive ones -> error output
                    next_state = STATE_ERR;
            end

            // Output states assert output for one cycle, then return to counting
            STATE_DISC: begin
                // After output asserted, return to counting state
                // Reset counter after discarding the stuffed zero (input was zero),
                // so counter resets to 0 for next cycle.
                next_state = STATE_COUNT;
                next_counter = 3'd0;
            end

            STATE_FLAG: begin
                // After output asserted, return to counting state,
                // reset counter after flag pattern (zero input)
                next_state = STATE_COUNT;
                next_counter = 3'd0;
            end

            STATE_ERR: begin
                // Remain in error state if input continues to be 1,
                // else return to counting state (counter reset).
                if (in)
                    next_state = STATE_ERR;
                else begin
                    next_state = STATE_COUNT;
                    next_counter = 3'd0;
                end
            end

            default: begin
                next_state = STATE_COUNT;
                next_counter = 3'd0;
            end
        endcase
    end

    // State and counter registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state   <= STATE_COUNT;
            counter <= 3'd0;
            disc    <= 1'b0;
            flag    <= 1'b0;
            err     <= 1'b0;
        end else begin
            state   <= next_state;
            counter <= next_counter;

            // Outputs depend only on state (Moore outputs)
            disc <= (next_state == STATE_DISC);
            flag <= (next_state == STATE_FLAG);
            err  <= (next_state == STATE_ERR);
        end
    end

endmodule