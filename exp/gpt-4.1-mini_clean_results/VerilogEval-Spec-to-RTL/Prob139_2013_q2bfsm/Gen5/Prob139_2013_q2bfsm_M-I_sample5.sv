module TopModule(
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding (Moore FSM)
    typedef enum logic [2:0] {
        A            = 3'd0, // Reset state
        F_PULSE      = 3'd1, // Output f=1 one cycle after reset deassert
        MONITOR_X    = 3'd2, // Monitor x pattern 1,0,1
        G_ON_MONITOR_Y = 3'd3, // g=1, monitor y for up to 2 cycles
        G_ON_PERM    = 3'd4, // g=1 permanently
        G_OFF_PERM   = 3'd5  // g=0 permanently
    } state_t;

    state_t state, next_state;

    // pattern_step tracks how many bits of pattern matched on x input:
    // 0 = waiting for first '1'
    // 1 = got first '1', waiting for '0'
    // 2 = got '1','0', waiting for last '1'
    // 3 = pattern matched
    reg [1:0] pattern_step;

    // y_count counts how many cycles in G_ON_MONITOR_Y state (max 2)
    reg [1:0] y_count;

    // Sequential state and registers update
    always @(posedge clk) begin
        if (!resetn) begin
            state        <= A;
            f            <= 1'b0;
            g            <= 1'b0;
            pattern_step <= 2'd0;
            y_count      <= 2'd0;
        end else begin
            state <= next_state;

            // Update pattern_step only in MONITOR_X state
            if (state == MONITOR_X) begin
                case (pattern_step)
                    2'd0: pattern_step <= (x == 1'b1) ? 2'd1 : 2'd0;
                    2'd1: pattern_step <= (x == 1'b0) ? 2'd2 : ((x == 1'b1) ? 2'd1 : 2'd0);
                    2'd2: pattern_step <= (x == 1'b1) ? 2'd3 : 2'd0;
                    2'd3: pattern_step <= 2'd3; // pattern matched, hold
                    default: pattern_step <= 2'd0;
                endcase
            end else begin
                pattern_step <= 2'd0;
            end

            // Update y_count only in G_ON_MONITOR_Y state
            if (state == G_ON_MONITOR_Y) begin
                y_count <= y_count + 1'b1;
            end else begin
                y_count <= 2'd0;
            end

            // Outputs depend on current state (Moore outputs)
            case (next_state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                F_PULSE: begin
                    f <= 1'b1;
                    g <= 1'b0;
                end
                MONITOR_X: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                G_ON_MONITOR_Y: begin
                    f <= 1'b0;
                    g <= 1'b1;
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
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;

        case (state)
            A: begin
                // Wait for reset to deassert
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = A;
            end

            F_PULSE: begin
                // After producing f=1 for one clock cycle, start monitoring x
                next_state = MONITOR_X;
            end

            MONITOR_X: begin
                if (pattern_step == 2'd3) begin
                    // pattern matched, move to monitor y with g=1
                    next_state = G_ON_MONITOR_Y;
                end else begin
                    next_state = MONITOR_X;
                end
            end

            G_ON_MONITOR_Y: begin
                if (y == 1'b1) begin
                    // y=1 within 2 cycles, stay permanently g=1
                    next_state = G_ON_PERM;
                end else if (y_count >= 2'd2) begin
                    // y never became 1 in 2 cycles, g=0 permanently
                    next_state = G_OFF_PERM;
                end else begin
                    // keep monitoring y
                    next_state = G_ON_MONITOR_Y;
                end
            end

            G_ON_PERM: begin
                // Hold g=1 forever until reset
                next_state = G_ON_PERM;
            end

            G_OFF_PERM: begin
                // Hold g=0 forever until reset
                next_state = G_OFF_PERM;
            end

            default: begin
                next_state = A;
            end
        endcase
    end

endmodule