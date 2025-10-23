module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding using parameters for pure Verilog
    parameter A              = 3'd0; // Reset state
    parameter F_PULSE        = 3'd1; // f=1 pulse after reset release
    parameter MONITOR_X      = 3'd2; // Monitor x input for pattern 1,0,1
    parameter G_ON_MONITOR_Y = 3'd3; // g=1, monitor y up to 2 cycles
    parameter G_ON_PERM      = 3'd4; // g=1 permanently
    parameter G_OFF_PERM     = 3'd5; // g=0 permanently

    reg [2:0] state, next_state;

    // Detect reset release: delay resetn to detect rising edge
    reg resetn_d;

    // Pattern step: 0=wait 1, 1=wait 0, 2=wait 1, 3=matched
    reg [1:0] pattern_step;

    // Counter for y monitoring (max 2 cycles)
    reg [1:0] y_count;

    // Sequential block: state and registers update
    always @(posedge clk) begin
        resetn_d <= resetn;

        if (!resetn) begin
            state        <= A;
            pattern_step <= 2'd0;
            y_count      <= 2'd0;
            f            <= 1'b0;
            g            <= 1'b0;
        end else begin
            state <= next_state;

            // Update outputs based on next_state (Moore outputs)
            case (next_state)
                F_PULSE: f <= 1'b1;
                default: f <= 1'b0;
            endcase

            case (next_state)
                G_ON_MONITOR_Y,
                G_ON_PERM: g <= 1'b1;
                G_OFF_PERM,
                A,
                F_PULSE,
                MONITOR_X: g <= 1'b0;
                default: g <= 1'b0;
            endcase

            // Update pattern_step only in MONITOR_X state
            if (next_state == MONITOR_X) begin
                case (pattern_step)
                    2'd0: pattern_step <= (x == 1'b1) ? 2'd1 : 2'd0;
                    2'd1: pattern_step <= (x == 1'b0) ? 2'd2 :
                                          (x == 1'b1) ? 2'd1 : 2'd0;
                    2'd2: pattern_step <= (x == 1'b1) ? 2'd3 : 2'd0;
                    2'd3: pattern_step <= 2'd3; // hold matched
                    default: pattern_step <= 2'd0;
                endcase
            end else begin
                pattern_step <= 2'd0;
            end

            // Update y_count only in G_ON_MONITOR_Y
            if (next_state == G_ON_MONITOR_Y)
                y_count <= y_count + 1'b1;
            else
                y_count <= 2'd0;
        end
    end

    // Combinational logic for next_state
    always @(*) begin
        next_state = state;

        // Detect reset release event (rising edge of resetn)
        wire reset_release = resetn & ~resetn_d;

        case (state)
            A: begin
                if (reset_release)
                    next_state = F_PULSE;
                else
                    next_state = A;
            end

            F_PULSE: next_state = MONITOR_X;

            MONITOR_X: begin
                if (pattern_step == 2'd3)
                    next_state = G_ON_MONITOR_Y;
                else
                    next_state = MONITOR_X;
            end

            G_ON_MONITOR_Y: begin
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else if (y_count >= 2'd2)
                    next_state = G_OFF_PERM;
                else
                    next_state = G_ON_MONITOR_Y;
            end

            G_ON_PERM: next_state = G_ON_PERM;

            G_OFF_PERM: next_state = G_OFF_PERM;

            default: next_state = A;
        endcase
    end

endmodule