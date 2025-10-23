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

    reg [2:0] x_shift;       // shift register for last 3 samples of x
    reg [1:0] y_timer;       // counts how many cycles spent monitoring y

    // Sequential logic: state and registers update on posedge clk with synchronous active low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= STATE_A;
            x_shift <= 3'b000;
            y_timer <= 2'd0;
        end else begin
            state <= next_state;

            case (state)
                STATE_A: begin
                    x_shift <= 3'b000;
                    y_timer <= 2'd0;
                end

                STATE_B: begin
                    x_shift <= 3'b000;
                    y_timer <= 2'd0;
                end

                STATE_C: begin
                    // Shift in new x sample every cycle
                    x_shift <= {x_shift[1:0], x};
                    y_timer <= 2'd0;
                end

                STATE_D: begin
                    // One cycle g pulse done, prepare to monitor y
                    y_timer <= 2'd0;
                    // x_shift held as is (not relevant)
                end

                STATE_E: begin
                    y_timer <= y_timer + 1'b1;
                    // x_shift held as is (not relevant)
                end

                STATE_F: begin
                    // Permanent g=1 state - hold timers/registers
                    // no change
                end

                STATE_G: begin
                    // Permanent g=0 state - hold timers/registers
                    // no change
                end

                default: begin
                    x_shift <= 3'b000;
                    y_timer <= 2'd0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            STATE_A: begin
                if (resetn)
                    next_state = STATE_B;
            end

            STATE_B: begin
                // After f pulse, move to monitor x pattern
                next_state = STATE_C;
            end

            STATE_C: begin
                // Check pattern 1,0,1 in x_shift continuously once we have 3 bits
                // Wait until x_shift has valid data (i.e. after at least 3 shifts)
                // However, shifting starts immediately; the initial zeros do not match the pattern so safe to check always
                if (x_shift == 3'b101)
                    next_state = STATE_D;
                else
                    next_state = STATE_C; // keep monitoring
            end

            STATE_D: begin
                // One cycle g=1 pulse done, move to monitor y
                next_state = STATE_E;
            end

            STATE_E: begin
                if (y == 1'b1) begin
                    next_state = STATE_F;
                end else if (y_timer == 2'd2) begin
                    next_state = STATE_G;
                end else begin
                    next_state = STATE_E; // keep monitoring
                end
            end

            STATE_F: begin
                next_state = STATE_F; // permanent g=1
            end

            STATE_G: begin
                next_state = STATE_G; // permanent g=0
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