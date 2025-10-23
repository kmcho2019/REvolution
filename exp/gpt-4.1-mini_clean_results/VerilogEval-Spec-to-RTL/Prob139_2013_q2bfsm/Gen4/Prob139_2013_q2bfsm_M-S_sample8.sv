module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    typedef enum logic [2:0] {
        A = 3'd0,
        F_PULSE = 3'd1,
        MONITOR_X = 3'd2,
        G_ON_MONITOR_Y = 3'd3,
        G_ON_PERM = 3'd4,
        G_OFF_PERM = 3'd5
    } state_t;

    state_t state, next_state;

    reg [1:0] pattern_step;    // tracks which x bit we expect: 0=wait 1,1=wait0,2=wait1,3=matched
    reg [1:0] y_count;         // counts y monitor cycles (max 2)

    // State and output register
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            f <= 1'b0;
            g <= 1'b0;
            pattern_step <= 2'd0;
            y_count <= 2'd0;
        end else begin
            state <= next_state;

            case (next_state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    pattern_step <= 2'd0;
                    y_count <= 2'd0;
                end

                F_PULSE: begin
                    f <= 1'b1;
                    g <= 1'b0;
                    pattern_step <= 2'd0;
                    y_count <= 2'd0;
                end

                MONITOR_X: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    y_count <= 2'd0;
                    // pattern_step updated in combinational logic
                end

                G_ON_MONITOR_Y: begin
                    f <= 1'b0;
                    g <= 1'b1;
                    // y_count incremented in sequential logic below
                end

                G_ON_PERM: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end

                G_OFF_PERM: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end

                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    pattern_step <= 2'd0;
                    y_count <= 2'd0;
                end
            endcase

            // Update pattern_step in MONITOR_X state based on x input and current step
            if (next_state == MONITOR_X) begin
                case (pattern_step)
                    2'd0: pattern_step <= (x == 1'b1) ? 2'd1 : 2'd0;
                    2'd1: pattern_step <= (x == 1'b0) ? 2'd2 : ((x == 1'b1) ? 2'd1 : 2'd0);
                    2'd2: pattern_step <= (x == 1'b1) ? 2'd3 : 2'd0;
                    2'd3: pattern_step <= 2'd3; // pattern matched
                    default: pattern_step <= 2'd0;
                endcase
            end else if (next_state == A || next_state == F_PULSE) begin
                pattern_step <= 2'd0;
            end

            // Update y_count in G_ON_MONITOR_Y state
            if (state == G_ON_MONITOR_Y) begin
                y_count <= y_count + 1'b1;
            end else begin
                y_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold state

        case (state)
            A: begin
                // On reset de-assert, go to F_PULSE to produce f=1 for one cycle
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = A;
            end

            F_PULSE: begin
                // After f=1 pulse, start monitoring x for pattern
                next_state = MONITOR_X;
            end

            MONITOR_X: begin
                if (pattern_step == 2'd3) begin
                    // pattern matched, start monitoring y
                    next_state = G_ON_MONITOR_Y;
                end else begin
                    next_state = MONITOR_X;
                end
            end

            G_ON_MONITOR_Y: begin
                // If y=1 anytime during the 2 cycles, hold g=1 permanently
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else if (y_count == 2'd1)
                    // first cycle monitoring y, continue
                    next_state = G_ON_MONITOR_Y;
                else if (y_count >= 2'd2)
                    // 2 cycles elapsed, no y=1 -> g=0 permanently
                    next_state = G_OFF_PERM;
                else
                    next_state = G_ON_MONITOR_Y;
            end

            G_ON_PERM: begin
                // Hold g=1 permanently until reset
                next_state = G_ON_PERM;
            end

            G_OFF_PERM: begin
                // Hold g=0 permanently until reset
                next_state = G_OFF_PERM;
            end

            default: begin
                next_state = A;
            end
        endcase
    end

endmodule