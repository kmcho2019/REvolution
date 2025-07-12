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
        STATE_A  = 4'd0, // reset state, f=0, g=0
        STATE_B  = 4'd1, // f=1 pulse (one cycle after reset deasserted)
        STATE_C0 = 4'd2, // wait for x=1 (start pattern detection)
        STATE_C1 = 4'd3, // got x=1, wait for x=0
        STATE_C2 = 4'd4, // got 1,0, wait for x=1
        STATE_D  = 4'd5, // g=1 pulse (one cycle after pattern detected)
        STATE_E0 = 4'd6, // monitor y cycle 1 with g=1
        STATE_E1 = 4'd7, // monitor y cycle 2 with g=1
        STATE_F  = 4'd8, // permanent g=1
        STATE_G  = 4'd9  // permanent g=0
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

            // Output f logic
            case (state)
                STATE_B:  f <= 1'b1;
                default:  f <= 1'b0;
            endcase

            // Output g logic
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
                // Stay in reset state while resetn is low
                if (resetn)
                    next_state = STATE_B; // after reset deassertion, pulse f=1 next clock
                else
                    next_state = STATE_A;
            end

            STATE_B: begin
                // After one cycle f=1 pulse, start pattern detection
                next_state = STATE_C0;
            end

            // Pattern detection: wait for exact sequence 1,0,1 in successive cycles
            STATE_C0: begin
                if (x == 1'b1)
                    next_state = STATE_C1;
                else
                    next_state = STATE_C0;
            end

            STATE_C1: begin
                if (x == 1'b0)
                    next_state = STATE_C2;
                else
                    next_state = STATE_C0; // restart detection if x not 0
            end

            STATE_C2: begin
                if (x == 1'b1)
                    next_state = STATE_D; // pattern detected
                else
                    next_state = STATE_C0; // restart detection if x not 1
            end

            STATE_D: begin
                // One cycle pulse of g=1, then start monitoring y input
                next_state = STATE_E0;
            end

            // Monitor y for two cycles max while holding g=1
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
                // Hold permanent g=1 until reset
                next_state = STATE_F;
            end

            STATE_G: begin
                // Hold permanent g=0 until reset
                next_state = STATE_G;
            end

            default: begin
                // Safe fallback to reset
                next_state = STATE_A;
            end
        endcase
    end

endmodule