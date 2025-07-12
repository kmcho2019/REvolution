module TopModule (
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // State encoding with parameters for clarity
    localparam [3:0]
        STATE_A    = 4'd0, // Reset state, f=0,g=0
        STATE_B    = 4'd1, // f=1 pulse (one cycle after reset deassert)
        STATE_C0   = 4'd2, // Wait for x=1
        STATE_C1   = 4'd3, // Got x=1, wait for x=0
        STATE_C2   = 4'd4, // Got 1,0, wait for x=1
        STATE_PULSE_G = 4'd5, // One clock cycle pulse g=1 (after pattern detection)
        STATE_E0   = 4'd6, // Monitor y first cycle with g=1
        STATE_E1   = 4'd7, // Monitor y second cycle with g=1
        STATE_PERM_G1 = 4'd8, // Permanent g=1
        STATE_PERM_G0 = 4'd9; // Permanent g=0

    reg [3:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
        end else begin
            state <= next_state;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            STATE_A: begin
                // Hold in reset state while resetn=0
                if (resetn)
                    next_state = STATE_B; // f=1 pulse next clock
                else
                    next_state = STATE_A;
            end

            STATE_B: begin
                // f=1 for one clock cycle done, start pattern detection
                next_state = STATE_C0;
            end

            // Pattern detection: look strictly for 1,0,1 in successive clocks on x
            STATE_C0: begin
                if (x == 1'b1)
                    next_state = STATE_C1;
                else
                    next_state = STATE_C0; // stay waiting for x=1
            end

            STATE_C1: begin
                if (x == 1'b0)
                    next_state = STATE_C2;
                else if (x == 1'b1)
                    next_state = STATE_C1; // remain until 0 detected
                else
                    next_state = STATE_C0; // unexpected, restart detection
            end

            STATE_C2: begin
                if (x == 1'b1)
                    next_state = STATE_PULSE_G; // pattern matched
                else
                    next_state = STATE_C0; // restart detection on any other x
            end

            // One clock cycle pulse of g=1 after pattern detected
            STATE_PULSE_G: begin
                next_state = STATE_E0; // start monitoring y next
            end

            // Monitor y first cycle
            STATE_E0: begin
                if (y == 1'b1)
                    next_state = STATE_PERM_G1; // permanent g=1
                else
                    next_state = STATE_E1;      // second monitoring cycle
            end

            // Monitor y second cycle
            STATE_E1: begin
                if (y == 1'b1)
                    next_state = STATE_PERM_G1; // permanent g=1
                else
                    next_state = STATE_PERM_G0; // permanent g=0
            end

            // Permanent g=1 until reset
            STATE_PERM_G1: next_state = STATE_PERM_G1;

            // Permanent g=0 until reset
            STATE_PERM_G0: next_state = STATE_PERM_G0;

            default: next_state = STATE_A;
        endcase
    end

    // Outputs are purely combinational from current state
    assign f = (state == STATE_B) ? 1'b1 : 1'b0;
    assign g = (state == STATE_PULSE_G) ||
               (state == STATE_E0) ||
               (state == STATE_E1) ||
               (state == STATE_PERM_G1);

endmodule