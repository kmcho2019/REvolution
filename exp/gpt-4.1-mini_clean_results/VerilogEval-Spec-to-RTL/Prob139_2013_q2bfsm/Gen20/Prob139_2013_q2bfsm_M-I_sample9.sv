module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum logic [2:0] {
        STATE_A = 3'd0, // Reset state, f=0,g=0
        STATE_B = 3'd1, // f=1 pulse one cycle after reset release
        STATE_C = 3'd2, // Monitor x input for pattern 1-0-1
        STATE_D = 3'd3, // g=1 pulse one cycle (after pattern detect)
        STATE_E = 3'd4, // Monitor y input up to 2 cycles with g=1
        STATE_F = 3'd5, // Permanent g=1 until reset
        STATE_G = 3'd6  // Permanent g=0 until reset
    } state_t;

    state_t state, next_state;

    reg [2:0] x_shift;      // last 3 samples of x, shift left, newest in LSB
    reg [1:0] x_sample_count; // counts how many x samples collected in STATE_C (0..2)
    reg [1:0] y_timer;      // counts 1 or 2 cycles in STATE_E to monitor y

    // Sequential logic: state and registers update on posedge clk with synchronous active low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state          <= STATE_A;
            x_shift        <= 3'b000;
            x_sample_count <= 2'd0;
            y_timer        <= 2'd0;
        end else begin
            state <= next_state;

            case (state)
                STATE_A: begin
                    // Reset state - clear registers
                    x_shift        <= 3'b000;
                    x_sample_count <= 2'd0;
                    y_timer        <= 2'd0;
                end

                STATE_B: begin
                    // f pulse one cycle, clear shift regs and counters preparing for x monitoring
                    x_shift        <= 3'b000;
                    x_sample_count <= 2'd0;
                    y_timer        <= 2'd0;
                end

                STATE_C: begin
                    // Shift in new x sample every cycle and count samples up to 3
                    // We delay pattern checking until x_sample_count == 2 (means 3 samples total: counts 0,1,2)
                    x_shift        <= {x_shift[1:0], x};
                    if (x_sample_count < 2)
                        x_sample_count <= x_sample_count + 1'b1;
                    else
                        x_sample_count <= x_sample_count; // saturate at 2
                    y_timer        <= 2'd0; // reset y timer here
                end

                STATE_D: begin
                    // g pulse one cycle after pattern detected, prepare y monitoring timer
                    x_shift        <= x_shift; // hold x_shift (not used here)
                    x_sample_count <= x_sample_count;
                    y_timer        <= 2'd0;
                end

                STATE_E: begin
                    // Monitor y input with g=1 for at most two clock cycles
                    x_shift        <= x_shift; // hold
                    x_sample_count <= x_sample_count; // hold
                    y_timer        <= y_timer + 1'b1;
                end

                STATE_F: begin
                    // Permanent g=1, hold registers as is
                    x_shift        <= x_shift;
                    x_sample_count <= x_sample_count;
                    y_timer        <= y_timer;
                end

                STATE_G: begin
                    // Permanent g=0, hold registers as is
                    x_shift        <= x_shift;
                    x_sample_count <= x_sample_count;
                    y_timer        <= y_timer;
                end

                default: begin
                    // Safety fallback
                    x_shift        <= 3'b000;
                    x_sample_count <= 2'd0;
                    y_timer        <= 2'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            STATE_A: begin
                // Remain in STATE_A while resetn==0
                // Move to STATE_B exactly one cycle *after* resetn is detected high
                if (resetn)
                    next_state = STATE_B;
            end

            STATE_B: begin
                // One cycle pulse of f=1, then move to monitoring x pattern
                next_state = STATE_C;
            end

            STATE_C: begin
                // After 3 valid x samples (x_sample_count == 2) check pattern
                if (x_sample_count == 2) begin
                    if (x_shift == 3'b101)
                        next_state = STATE_D;
                    else
                        next_state = STATE_C;
                end else begin
                    // Not enough samples yet, keep collecting
                    next_state = STATE_C;
                end
            end

            STATE_D: begin
                // One cycle g=1 pulse, then move to y monitoring with timer start
                next_state = STATE_E;
            end

            STATE_E: begin
                // Monitor y for at most two cycles (y_timer counts 1 or 2)
                // y_timer starts at 0 on entry, increments to 1, then 2 on subsequent cycles
                // If y==1 at any cycle within these two cycles, go to permanent g=1 (STATE_F)
                // If y_timer == 2 and y still 0, go to permanent g=0 (STATE_G)
                if (y == 1'b1)
                    next_state = STATE_F;
                else if (y_timer == 2'd2)
                    next_state = STATE_G;
                else
                    next_state = STATE_E;
            end

            STATE_F: begin
                // Permanent g=1 state until reset
                next_state = STATE_F;
            end

            STATE_G: begin
                // Permanent g=0 state until reset
                next_state = STATE_G;
            end

            default: begin
                next_state = STATE_A;
            end
        endcase
    end

    // Moore output logic - outputs depend only on current state
    always @(*) begin
        f = 1'b0;
        g = 1'b0;

        case (state)
            STATE_B: f = 1'b1;           // single cycle f=1 after reset release
            STATE_D: g = 1'b1;           // single cycle g=1 pulse after pattern detection
            STATE_E: g = 1'b1;           // hold g=1 while monitoring y
            STATE_F: g = 1'b1;           // permanent g=1 after y=1 detected
            // g=0 in all other states
        endcase
    end

endmodule