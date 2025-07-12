module TopModule(
    input wire clk,
    input wire resetn,
    input wire x,
    input wire y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum logic [2:0] {
        A           = 3'd0, // Reset state
        F_PULSE     = 3'd1, // Output f=1 for one cycle
        MONITOR_X   = 3'd2, // Detect 1,0,1 pattern on x
        G_MONITOR_Y = 3'd3, // g=1, monitor y for up to 2 cycles
        G_ON        = 3'd4, // g=1 permanently
        G_OFF       = 3'd5  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // pattern_match_index indicates which bit of pattern we expect next:
    // 0: expect first '1'
    // 1: expect '0'
    // 2: expect last '1'
    // 3: pattern matched (transition)
    reg [1:0] pattern_match_index;

    // counts how many cycles y has been monitored (0,1,2)
    reg [1:0] y_counter;

    // State register
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            pattern_match_index <= 2'd0;
            y_counter <= 2'd0;
        end else begin
            state <= next_state;
            // Update pattern_match_index only in MONITOR_X state
            if (state == MONITOR_X) begin
                // Pattern to detect: 1,0,1 in three consecutive cycles on x
                // pattern_match_index = 0: expect '1'
                // pattern_match_index = 1: expect '0'
                // pattern_match_index = 2: expect '1'
                case (pattern_match_index)
                    2'd0: pattern_match_index <= (x == 1'b1) ? 2'd1 : 2'd0;
                    2'd1: pattern_match_index <= (x == 1'b0) ? 2'd2 : (x == 1'b1 ? 2'd1 : 2'd0);
                    2'd2: pattern_match_index <= (x == 1'b1) ? 2'd3 : 2'd0; // 3 means pattern matched
                    default: pattern_match_index <= 2'd0;
                endcase
            end else begin
                pattern_match_index <= 2'd0; // reset outside MONITOR_X
            end

            // Update y_counter only in G_MONITOR_Y state
            if (state == G_MONITOR_Y) begin
                y_counter <= y_counter + 1'b1;
            end else begin
                y_counter <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold
        case (state)
            A: begin
                // Wait for reset release
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = A;
            end

            F_PULSE: begin
                // One cycle f=1, then start pattern detection
                next_state = MONITOR_X;
            end

            MONITOR_X: begin
                // Wait until pattern_match_index == 3 (pattern matched)
                if (pattern_match_index == 2'd3)
                    next_state = G_MONITOR_Y;
                else
                    next_state = MONITOR_X;
            end

            G_MONITOR_Y: begin
                // g=1, monitor y for 2 cycles max
                if (y == 1'b1)
                    next_state = G_ON;  // g=1 permanently
                else if (y_counter == 2'd2)
                    next_state = G_OFF; // g=0 permanently
                else
                    next_state = G_MONITOR_Y;
            end

            G_ON: begin
                // Hold g=1 permanently until reset
                next_state = G_ON;
            end

            G_OFF: begin
                // Hold g=0 permanently until reset
                next_state = G_OFF;
            end

            default: next_state = A;
        endcase
    end

    // Output logic (Moore machine: outputs depend only on current state)
    always @(*) begin
        case (state)
            A: begin
                f = 1'b0;
                g = 1'b0;
            end
            F_PULSE: begin
                f = 1'b1;
                g = 1'b0;
            end
            MONITOR_X: begin
                f = 1'b0;
                g = 1'b0;
            end
            G_MONITOR_Y: begin
                f = 1'b0;
                g = 1'b1;
            end
            G_ON: begin
                f = 1'b0;
                g = 1'b1;
            end
            G_OFF: begin
                f = 1'b0;
                g = 1'b0;
            end
            default: begin
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule