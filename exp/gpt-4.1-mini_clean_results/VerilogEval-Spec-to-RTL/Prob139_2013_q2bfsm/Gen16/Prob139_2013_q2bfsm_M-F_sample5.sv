module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    typedef enum logic [3:0] {
        STATE_A     = 4'd0,  // reset state, wait resetn=1
        STATE_WAIT  = 4'd1,  // wait one cycle after resetn=1 before f pulse
        STATE_B     = 4'd2,  // f=1 pulse (one cycle)
        STATE_C0    = 4'd3,  // waiting for x=1 (pattern start)
        STATE_C1    = 4'd4,  // waiting for x=0
        STATE_C2    = 4'd5,  // waiting for x=1
        STATE_D     = 4'd6,  // g=1 pulse (one cycle)
        STATE_E0    = 4'd7,  // monitor y first cycle with g=1
        STATE_E1    = 4'd8,  // monitor y second cycle with g=1
        STATE_F     = 4'd9,  // g=1 permanent
        STATE_G     = 4'd10  // g=0 permanent
    } state_t;

    state_t state, next_state;

    // Sequential state register with synchronous active low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            STATE_A: begin
                // Stay here while resetn=0
                if (resetn)
                    next_state = STATE_WAIT;  // after resetn=1, wait one cycle
                else
                    next_state = STATE_A;
            end
            STATE_WAIT: begin
                // One cycle wait after resetn=1 before f=1 pulse
                next_state = STATE_B;
            end
            STATE_B: begin
                // f=1 one cycle pulse done, now detect pattern on x
                next_state = STATE_C0;
            end
            STATE_C0: begin
                // Expect x=1 to start pattern
                if (x == 1'b1)
                    next_state = STATE_C1;
                else
                    next_state = STATE_C0; // keep waiting for x=1
            end
            STATE_C1: begin
                // Expect x=0 next cycle
                if (x == 1'b0)
                    next_state = STATE_C2;
                else if (x == 1'b1)
                    next_state = STATE_C1; // stay here until x=0 to ensure sequence
                else
                    next_state = STATE_C0; // mismatch, restart pattern detection
            end
            STATE_C2: begin
                // Expect x=1 next cycle
                if (x == 1'b1)
                    next_state = STATE_D;   // pattern matched
                else if (x == 1'b0)
                    next_state = STATE_C0;  // mismatch, restart pattern detection
                else
                    next_state = STATE_C0;  // mismatch, restart pattern detection
            end
            STATE_D: begin
                // One cycle g=1 pulse done, now monitor y
                next_state = STATE_E0;
            end
            STATE_E0: begin
                if (y == 1'b1)
                    next_state = STATE_F; // y detected within 1st cycle
                else
                    next_state = STATE_E1; // monitor next cycle
            end
            STATE_E1: begin
                if (y == 1'b1)
                    next_state = STATE_F; // y detected within 2nd cycle
                else
                    next_state = STATE_G; // y not detected in 2 cycles
            end
            STATE_F: begin
                // g=1 permanent until reset
                next_state = STATE_F;
            end
            STATE_G: begin
                // g=0 permanent until reset
                next_state = STATE_G;
            end
            default: begin
                next_state = STATE_A;
            end
        endcase
    end

    // Output logic (Moore machine)
    always @(posedge clk) begin
        if (!resetn) begin
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            case (state)
                STATE_A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                STATE_WAIT: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                STATE_B: begin
                    f <= 1'b1; // one cycle pulse after reset delay
                    g <= 1'b0;
                end
                STATE_C0, STATE_C1, STATE_C2: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                STATE_D: begin
                    f <= 1'b0;
                    g <= 1'b1; // one cycle pulse g=1
                end
                STATE_E0, STATE_E1: begin
                    f <= 1'b0;
                    g <= 1'b1; // hold g=1 while monitoring y
                end
                STATE_F: begin
                    f <= 1'b0;
                    g <= 1'b1; // permanent g=1
                end
                STATE_G: begin
                    f <= 1'b0;
                    g <= 1'b0; // permanent g=0
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

endmodule