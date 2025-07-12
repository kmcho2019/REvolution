module TopModule (
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum reg [3:0] {
        STATE_A  = 4'd0, // Reset active: f=0,g=0
        STATE_B  = 4'd1, // f=1 pulse (1 cycle after reset deassertion)
        STATE_C0 = 4'd2, // Pattern detection wait for x=1
        STATE_C1 = 4'd3, // Got x=1, wait x=0
        STATE_C2 = 4'd4, // Got 1,0, wait x=1
        STATE_D  = 4'd5, // Pattern detected, g=1 pulse (1 cycle)
        STATE_E0 = 4'd6, // Monitor y cycle 1 with g=1
        STATE_E1 = 4'd7, // Monitor y cycle 2 with g=1
        STATE_F  = 4'd8, // Permanent g=1
        STATE_G  = 4'd9  // Permanent g=0
    } state_t;

    state_t state, next_state;

    // Sequential logic: state and outputs update on posedge clk
    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs depend solely on current state
            case (state)
                STATE_B:  f <= 1'b1;
                default:  f <= 1'b0;
            endcase

            case (state)
                STATE_D,
                STATE_E0,
                STATE_E1,
                STATE_F: g <= 1'b1;
                default: g <= 1'b0;
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            STATE_A: begin
                // Wait in reset until resetn deasserts
                if (resetn)
                    next_state = STATE_B; // pulse f=1 next clock cycle
                else
                    next_state = STATE_A;
            end

            STATE_B: begin
                // One clock cycle pulse f=1 done, start pattern detection
                next_state = STATE_C0;
            end

            // Pattern detection FSM for sequence x=1,0,1
            STATE_C0: begin
                if (x == 1'b1)
                    next_state = STATE_C1;
                else
                    next_state = STATE_C0;
            end

            STATE_C1: begin
                if (x == 1'b0)
                    next_state = STATE_C2;
                else // x==1
                    next_state = STATE_C1; // stay until 0 detected
            end

            STATE_C2: begin
                if (x == 1'b1)
                    next_state = STATE_D; // pattern 1,0,1 detected
                else // x == 0
                    next_state = STATE_C0; // restart pattern detection
            end

            STATE_D: begin
                // g=1 one cycle pulse done, start monitoring y with g=1
                next_state = STATE_E0;
            end

            // Monitor y for 2 clock cycles max, with g=1
            STATE_E0: begin
                if (y == 1'b1)
                    next_state = STATE_F; // permanent g=1
                else
                    next_state = STATE_E1; // second monitoring cycle
            end

            STATE_E1: begin
                if (y == 1'b1)
                    next_state = STATE_F; // permanent g=1
                else
                    next_state = STATE_G; // permanent g=0
            end

            STATE_F: begin
                // Permanent g=1 until reset
                next_state = STATE_F;
            end

            STATE_G: begin
                // Permanent g=0 until reset
                next_state = STATE_G;
            end

            default: begin
                next_state = STATE_A; // safe fallback
            end
        endcase
    end

endmodule