module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    localparam [2:0]
        RESET_STATE      = 3'd0,
        F_PULSE_STATE    = 3'd1,
        PATTERN_WAIT_STATE = 3'd2,
        G_PULSE_STATE    = 3'd3,
        Y_MONITOR_STATE  = 3'd4,
        G_ON_STATE       = 3'd5,
        G_OFF_STATE      = 3'd6;

    reg [2:0] state, next_state;

    // Shift register holding last 3 x samples (MSB oldest)
    reg [2:0] x_shift_reg, next_x_shift_reg;

    // Counter to track number of cycles in Y_MONITOR_STATE (max 2)
    reg [1:0] y_monitor_cnt, next_y_monitor_cnt;

    // Sequential state and registers update
    always @(posedge clk) begin
        if (!resetn) begin
            state         <= RESET_STATE;
            x_shift_reg   <= 3'b000;
            y_monitor_cnt <= 2'd0;
            f             <= 1'b0;
            g             <= 1'b0;
        end else begin
            state         <= next_state;
            x_shift_reg   <= next_x_shift_reg;
            y_monitor_cnt <= next_y_monitor_cnt;

            // Moore outputs assigned based on state
            case (next_state)
                F_PULSE_STATE:    f <= 1'b1;
                default:          f <= 1'b0;
            endcase

            case (next_state)
                G_PULSE_STATE,
                Y_MONITOR_STATE,
                G_ON_STATE:       g <= 1'b1;
                default:          g <= 1'b0;
            endcase
        end
    end

    // Combinational logic: next state, shift register, counter
    always @(*) begin
        // Defaults
        next_state       = state;
        next_x_shift_reg = x_shift_reg;
        next_y_monitor_cnt = y_monitor_cnt;

        case(state)
            RESET_STATE: begin
                // Stay here while reset asserted
                if (resetn) begin
                    next_state = F_PULSE_STATE;
                    next_x_shift_reg = 3'b000;
                    next_y_monitor_cnt = 2'd0;
                end else begin
                    next_state = RESET_STATE;
                    next_x_shift_reg = 3'b000;
                    next_y_monitor_cnt = 2'd0;
                end
            end

            F_PULSE_STATE: begin
                // f=1 for one cycle only, then move to pattern detection
                next_state = PATTERN_WAIT_STATE;
                // Initialize shift register with current x (just shifted in)
                // On entering pattern wait, shift in x once
                next_x_shift_reg = {x_shift_reg[1:0], x};
                next_y_monitor_cnt = 2'd0;
            end

            PATTERN_WAIT_STATE: begin
                // Shift in new x sample
                next_x_shift_reg = {x_shift_reg[1:0], x};

                // Check if pattern 3'b101 detected
                if (next_x_shift_reg == 3'b101) begin
                    // pattern detected
                    next_state = G_PULSE_STATE;
                    next_y_monitor_cnt = 2'd0;
                end else begin
                    next_state = PATTERN_WAIT_STATE;
                    next_y_monitor_cnt = 2'd0;
                end
            end

            G_PULSE_STATE: begin
                // g=1 for exactly one cycle, then start y monitoring
                next_state = Y_MONITOR_STATE;
                next_y_monitor_cnt = 2'd0;
                // Hold shift register as-is (no updates needed)
                next_x_shift_reg = x_shift_reg;
            end

            Y_MONITOR_STATE: begin
                // Keep g=1 while monitoring y for up to 2 cycles
                // If y=1 detected, latch g=1 permanently
                if (y == 1'b1) begin
                    next_state = G_ON_STATE;
                    next_y_monitor_cnt = 2'd0;
                end else if (y_monitor_cnt == 2'd1) begin
                    // Already monitored for 2 cycles (counting 0 and 1)
                    // y not detected, latch g=0 permanently
                    next_state = G_OFF_STATE;
                    next_y_monitor_cnt = 2'd0;
                end else begin
                    // Not detected y=1 yet, increment counter and continue
                    next_state = Y_MONITOR_STATE;
                    next_y_monitor_cnt = y_monitor_cnt + 1'b1;
                end
                // No shift register update needed here
                next_x_shift_reg = x_shift_reg;
            end

            G_ON_STATE: begin
                // g=1 permanently until reset
                next_state = G_ON_STATE;
                next_x_shift_reg = x_shift_reg;
                next_y_monitor_cnt = 2'd0;
            end

            G_OFF_STATE: begin
                // g=0 permanently until reset
                next_state = G_OFF_STATE;
                next_x_shift_reg = x_shift_reg;
                next_y_monitor_cnt = 2'd0;
            end

            default: begin
                // Safe default to reset state
                next_state = RESET_STATE;
                next_x_shift_reg = 3'b000;
                next_y_monitor_cnt = 2'd0;
            end
        endcase
    end

endmodule