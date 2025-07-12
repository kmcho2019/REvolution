module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding (binary)
    typedef enum logic [2:0] {
        S_A = 3'd0,   // reset state
        S_B = 3'd1,   // f=1 pulse after reset
        S_C = 3'd2,   // monitor x pattern 1,0,1
        S_D = 3'd3,   // g=1 pulse after pattern detected
        S_E = 3'd4,   // g=1 hold, monitor y for 2 cycles
        S_F = 3'd5,   // g=1 permanent
        S_G = 3'd6    // g=0 permanent
    } state_t;

    state_t state, next_state;

    // Shift register to track last three x samples
    reg [2:0] x_shift_reg, x_shift_next;

    // Counter to monitor y input in state E (0..2)
    reg [1:0] y_cnt, y_cnt_next;

    // Sequential logic: state, x_shift, y_cnt update with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state       <= S_A;
            x_shift_reg <= 3'b000;
            y_cnt       <= 2'd0;
            f           <= 1'b0;
            g           <= 1'b0;
        end else begin
            state       <= next_state;
            x_shift_reg <= x_shift_next;
            y_cnt       <= y_cnt_next;
            // Outputs f and g updated according to next_state logic below
            // But to keep outputs registered and avoid combinational glitches,
            // update outputs based on next_state deterministically:
            case (next_state)
                S_B: begin
                    // f=1 pulse one cycle after reset
                    f <= 1'b1;
                    g <= 1'b0;
                end
                S_D: begin
                    // g=1 pulse one cycle after pattern detected
                    f <= 1'b0;
                    g <= 1'b1;
                end
                S_E: begin
                    // g held at 1 while monitoring y
                    f <= 1'b0;
                    g <= 1'b1;
                end
                S_F: begin
                    // g=1 permanent hold
                    f <= 1'b0;
                    g <= 1'b1;
                end
                S_G: begin
                    // g=0 permanent hold
                    f <= 1'b0;
                    g <= 1'b0;
                end
                default: begin
                    // All other states f=0,g=0
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

    // Combinational next-state and inputs processing
    always @(*) begin
        // Default assignments: hold current values
        next_state    = state;
        x_shift_next  = x_shift_reg;
        y_cnt_next    = y_cnt;

        case (state)
            S_A: begin
                // Stay in reset state while resetn=0 (handled by sequential reset)
                // Once resetn=1, move to S_B on next clock
                next_state = S_B;
                // Clear shift register and counter as precaution
                x_shift_next = 3'b000;
                y_cnt_next = 2'd0;
            end

            S_B: begin
                // One cycle f=1 pulse issued (registered in sequential block)
                // After pulse move to state C to start pattern detection
                next_state = S_C;
                // Reset pattern shift register and counter
                x_shift_next = 3'b000;
                y_cnt_next = 2'd0;
            end

            S_C: begin
                // Shift in new x sample
                x_shift_next = {x_shift_reg[1:0], x};

                // Detect pattern 1,0,1 on the updated shift register
                // i.e., after shift x_shift_next == 3'b101
                if ({x_shift_reg[1:0], x} == 3'b101)
                    next_state = S_D;
                else
                    next_state = S_C;

                // Reset y counter (not used here)
                y_cnt_next = 2'd0;
            end

            S_D: begin
                // One cycle g=1 pulse (registered output)
                // Move to y-monitoring state E
                next_state = S_E;

                // Reset counters and shift registers
                x_shift_next = 3'b000;
                y_cnt_next = 2'd0;
            end

            S_E: begin
                // Hold g=1 while monitoring y for up to 2 cycles

                if (y == 1'b1) begin
                    // y=1 detected within allowed window: move to permanent g=1 hold
                    next_state = S_F;
                    y_cnt_next = 2'd0;
                end else if (y_cnt == 2'd1) begin
                    // Already waited 2 cycles without y=1, move to permanent g=0 hold
                    next_state = S_G;
                    y_cnt_next = 2'd0;
                end else begin
                    // Increment y count and remain in state E
                    y_cnt_next = y_cnt + 1'b1;
                    next_state = S_E;
                end

                // x_shift not needed in this state
                x_shift_next = 3'b000;
            end

            S_F: begin
                // Permanent g=1 hold until reset
                next_state = S_F;
                x_shift_next = 3'b000;
                y_cnt_next = 2'd0;
            end

            S_G: begin
                // Permanent g=0 hold until reset
                next_state = S_G;
                x_shift_next = 3'b000;
                y_cnt_next = 2'd0;
            end

            default: begin
                // Safety fallback
                next_state = S_A;
                x_shift_next = 3'b000;
                y_cnt_next = 2'd0;
            end
        endcase
    end

endmodule