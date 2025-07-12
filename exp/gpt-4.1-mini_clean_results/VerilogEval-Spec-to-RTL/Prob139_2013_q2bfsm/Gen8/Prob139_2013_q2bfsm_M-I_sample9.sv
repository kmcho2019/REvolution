module TopModule(
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding: 3 bits enough
    typedef enum logic [2:0] {
        A          = 3'd0, // Reset state
        F_PULSE    = 3'd1, // f=1 for 1 cycle
        MONITOR_X  = 3'd2, // Monitor x for pattern 1,0,1
        MONITOR_Y  = 3'd3, // g=1, monitor y for up to 2 cycles
        G_ON_PERM  = 3'd4, // g=1 permanently
        G_OFF_PERM = 3'd5  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // Track how many bits of pattern matched (0 to 3)
    reg [1:0] pattern_step;

    // Count clock cycles monitoring y (0,1,2)
    reg [1:0] y_count;

    // Sequential logic: state and counters with synchronous reset
    always @(posedge clk) begin
        if (!resetn) begin
            state        <= A;
            pattern_step <= 2'd0;
            y_count      <= 2'd0;
        end else begin
            state <= next_state;

            // Update pattern_step only in MONITOR_X
            if (next_state == MONITOR_X) begin
                case (pattern_step)
                    2'd0: pattern_step <= (x == 1'b1) ? 2'd1 : 2'd0;
                    2'd1: pattern_step <= (x == 1'b0) ? 2'd2 :
                                          (x == 1'b1) ? 2'd1 : 2'd0;
                    2'd2: pattern_step <= (x == 1'b1) ? 2'd3 : 2'd0;
                    2'd3: pattern_step <= 2'd3; // Hold matched
                    default: pattern_step <= 2'd0;
                endcase
            end else begin
                pattern_step <= 2'd0;
            end

            // Update y_count only in MONITOR_Y
            if (next_state == MONITOR_Y) begin
                if (state != MONITOR_Y)
                    y_count <= 2'd0; // Reset on entry
                else
                    y_count <= y_count + 1'b1;
            end else begin
                y_count <= 2'd0;
            end
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;

        case (state)
            A: begin
                if (resetn)
                    next_state = F_PULSE;
            end

            F_PULSE: begin
                // After one cycle pulse f=1
                next_state = MONITOR_X;
            end

            MONITOR_X: begin
                if (pattern_step == 2'd3)
                    next_state = MONITOR_Y;
            end

            MONITOR_Y: begin
                // If y=1 at any time within 2 cycles, go to G_ON_PERM
                // If after 2 cycles and y not 1, go to G_OFF_PERM
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else if (y_count == 2'd2)
                    next_state = G_OFF_PERM;
            end

            G_ON_PERM: begin
                if (!resetn)
                    next_state = A;
            end

            G_OFF_PERM: begin
                if (!resetn)
                    next_state = A;
            end

            default: next_state = A;
        endcase
    end

    // Moore outputs based solely on state
    always @(*) begin
        f = 1'b0;
        g = 1'b0;

        case (state)
            F_PULSE:    f = 1'b1;
            MONITOR_Y:  g = 1'b1;
            G_ON_PERM:  g = 1'b1;
            G_OFF_PERM: g = 1'b0;
            default: begin
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule