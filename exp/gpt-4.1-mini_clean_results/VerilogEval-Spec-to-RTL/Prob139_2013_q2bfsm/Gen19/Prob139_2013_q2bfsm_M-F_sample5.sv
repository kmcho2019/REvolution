module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    localparam [2:0]
        STATE_A = 3'd0,  // Reset state, f=0, g=0
        STATE_B = 3'd1,  // f=1 pulse (one cycle)
        STATE_C = 3'd2,  // Monitor x input for pattern 1-0-1
        STATE_D = 3'd3,  // g=1 pulse (one cycle)
        STATE_E = 3'd4,  // Monitor y input (up to 2 cycles) with g=1
        STATE_F = 3'd5,  // Permanent g=1 until reset
        STATE_G = 3'd6;  // Permanent g=0 until reset

    reg [2:0] state, next_state;

    reg [2:0] x_shift;     // Shift register holding last 3 samples of x
    reg [1:0] y_timer;     // Counts cycles monitoring y

    reg pattern_ready;     // Indicates when pattern detection can start (after 3 samples shifted in)

    // Sequential logic: state, registers update on posedge clk with synchronous active low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state        <= STATE_A;
            x_shift      <= 3'b000;
            y_timer      <= 2'd0;
            pattern_ready <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                STATE_A: begin
                    x_shift      <= 3'b000;
                    y_timer      <= 2'd0;
                    pattern_ready <= 1'b0;
                end

                STATE_B: begin
                    // After f pulse, prepare to monitor x
                    x_shift      <= 3'b000;
                    y_timer      <= 2'd0;
                    pattern_ready <= 1'b0;
                end

                STATE_C: begin
                    // Shift in new x sample
                    x_shift <= {x_shift[1:0], x};

                    // After 2 shifts (3 samples), pattern detection can start
                    // pattern_ready is set after 2 clock cycles in STATE_C
                    if (!pattern_ready)
                        pattern_ready <= 1'b1;

                    y_timer <= 2'd0;
                end

                STATE_D: begin
                    // One cycle g pulse done, prepare to monitor y
                    y_timer <= 2'd0;
                    // Hold x_shift and pattern_ready as is (not used here)
                end

                STATE_E: begin
                    // Count y monitoring cycles
                    y_timer <= y_timer + 1'b1;
                    // Hold x_shift and pattern_ready as is
                end

                STATE_F: begin
                    // Permanent g=1 state - hold timers/registers
                    // No change to registers
                end

                STATE_G: begin
                    // Permanent g=0 state - hold timers/registers
                    // No change to registers
                end

                default: begin
                    x_shift      <= 3'b000;
                    y_timer      <= 2'd0;
                    pattern_ready <= 1'b0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            STATE_A: begin
                // Wait here while resetn is low, move to B on resetn high
                if (resetn)
                    next_state = STATE_B;
            end

            STATE_B: begin
                // After pulse f=1, move to monitor x pattern
                next_state = STATE_C;
            end

            STATE_C: begin
                // Pattern detection enabled after pattern_ready=1
                if (pattern_ready) begin
                    // Pattern to detect: 1,0,1 (oldest bit x_shift[2], newest x_shift[0])
                    if (x_shift == 3'b101)
                        next_state = STATE_D;
                    else
                        next_state = STATE_C; // keep monitoring
                end else begin
                    // Not enough samples collected yet, stay here
                    next_state = STATE_C;
                end
            end

            STATE_D: begin
                // One cycle g=1 pulse done, move to monitor y
                next_state = STATE_E;
            end

            STATE_E: begin
                if (y == 1'b1) begin
                    // y detected within 2 cycles
                    next_state = STATE_F;
                end else if (y_timer == 2'd2) begin
                    // y not detected in 2 cycles
                    next_state = STATE_G;
                end else begin
                    next_state = STATE_E; // keep monitoring
                end
            end

            STATE_F: begin
                // Permanent g=1, stay here until reset
                next_state = STATE_F;
            end

            STATE_G: begin
                // Permanent g=0, stay here until reset
                next_state = STATE_G;
            end

            default: next_state = STATE_A;
        endcase
    end

    // Outputs combinational, Moore style based on current state
    always @(*) begin
        f = 1'b0;
        g = 1'b0;

        case (state)
            STATE_B: f = 1'b1;        // pulse f=1 for one cycle after reset release
            STATE_D: g = 1'b1;        // pulse g=1 one cycle after pattern detection
            STATE_E: g = 1'b1;        // hold g=1 while monitoring y
            STATE_F: g = 1'b1;        // permanent g=1 after y detected
            // g=0 in all other states by default
        endcase
    end

endmodule