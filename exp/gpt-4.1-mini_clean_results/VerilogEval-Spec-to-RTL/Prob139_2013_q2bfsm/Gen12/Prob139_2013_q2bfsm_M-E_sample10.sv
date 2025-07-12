module TopModule (
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State declarations
    typedef enum reg [3:0] {
        S_RESET     = 4'd0, // Reset active, f=0,g=0
        S_F_PULSE   = 4'd1, // Output f=1 for 1 cycle after resetn goes high
        // Pattern detection states for sequence x=1,0,1
        S_PAT_WAIT1 = 4'd2, // Wait for x=1
        S_PAT_WAIT0 = 4'd3, // Got 1, wait for 0
        S_PAT_WAIT1B= 4'd4, // Got 1,0, wait for 1 again
        S_G_PULSE   = 4'd5, // g=1 pulse for 1 cycle after pattern detected
        // Y monitoring states (g=1)
        S_Y_MON1    = 4'd6, // 1st cycle y monitoring with g=1
        S_Y_MON2    = 4'd7, // 2nd cycle y monitoring with g=1
        // Permanent output states
        S_G_PERM1   = 4'd8, // permanent g=1
        S_G_PERM0   = 4'd9  // permanent g=0
    } state_t;

    state_t state, next_state;

    // Sequential logic: state and outputs update on posedge clk
    always @(posedge clk) begin
        if (!resetn) begin
            state <= S_RESET;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs depend only on current state
            case (state)
                S_F_PULSE:   f <= 1'b1;
                default:     f <= 1'b0;
            endcase

            case (state)
                S_G_PULSE,
                S_Y_MON1,
                S_Y_MON2,
                S_G_PERM1:   g <= 1'b1;
                default:     g <= 1'b0;
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        // Default next state
        next_state = S_RESET;

        case (state)
            S_RESET: begin
                if (resetn)
                    next_state = S_F_PULSE; // release reset -> pulse f=1 next clock
                else
                    next_state = S_RESET;
            end

            S_F_PULSE: begin
                // f pulse done, start pattern detection wait for x=1
                next_state = S_PAT_WAIT1;
            end

            // Pattern detection FSM
            S_PAT_WAIT1: begin
                if (x == 1'b1)
                    next_state = S_PAT_WAIT0; // got 1, wait for 0
                else
                    next_state = S_PAT_WAIT1; // keep waiting
            end

            S_PAT_WAIT0: begin
                if (x == 1'b0)
                    next_state = S_PAT_WAIT1B; // got 0, wait for 1
                else if (x == 1'b1)
                    next_state = S_PAT_WAIT0; // stay waiting for 0 after 1
                else
                    next_state = S_PAT_WAIT1; // restart if somehow x unknown
            end

            S_PAT_WAIT1B: begin
                if (x == 1'b1)
                    next_state = S_G_PULSE; // pattern complete, pulse g=1
                else
                    next_state = S_PAT_WAIT1; // restart detection if failed
            end

            // g pulse one cycle
            S_G_PULSE: begin
                // start y monitoring with g=1
                next_state = S_Y_MON1;
            end

            // Monitor y for 2 cycles while g=1
            S_Y_MON1: begin
                if (y == 1'b1)
                    next_state = S_G_PERM1; // permanent g=1
                else
                    next_state = S_Y_MON2;  // 2nd cycle monitoring
            end

            S_Y_MON2: begin
                if (y == 1'b1)
                    next_state = S_G_PERM1; // permanent g=1
                else
                    next_state = S_G_PERM0; // permanent g=0
            end

            S_G_PERM1: begin
                // permanent g=1 until reset
                next_state = S_G_PERM1;
            end

            S_G_PERM0: begin
                // permanent g=0 until reset
                next_state = S_G_PERM0;
            end

            default: begin
                next_state = S_RESET; // safe fallback
            end
        endcase
    end

endmodule