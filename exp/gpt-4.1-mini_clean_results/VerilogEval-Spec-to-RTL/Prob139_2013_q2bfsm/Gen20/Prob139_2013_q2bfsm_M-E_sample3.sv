module TopModule (
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding (one-hot or binary)
    typedef enum logic [2:0] {
        STATE_A = 3'd0,  // Reset state, f=0, g=0
        STATE_B = 3'd1,  // f=1 pulse, one cycle
        STATE_C = 3'd2,  // Monitor x input with 3-bit shift register for pattern 1-0-1
        STATE_D = 3'd3,  // g=1 pulse, one cycle
        STATE_E = 3'd4,  // Monitor y input (max 2 cycles), g=1
        STATE_F = 3'd5,  // Permanent g=1
        STATE_G = 3'd6   // Permanent g=0
    } state_t;

    state_t state, next_state;

    reg [2:0] x_shift;  // Holds last 3 x samples: oldest bit x_shift[2], newest x_shift[0]
    reg [1:0] y_count;  // Counts y monitoring cycles in STATE_E

    // Synchronous state and registers update
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= STATE_A;
            x_shift <= 3'b000;
            y_count <= 2'd0;
            f       <= 1'b0;
            g       <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                STATE_A: begin
                    // In reset state, outputs low
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end

                STATE_B: begin
                    // f=1 pulse state, outputs updated combinationally, but also set here for safety
                    f <= 1'b1;
                    g <= 1'b0;
                    x_shift <= 3'b000; // start fresh collecting x
                    y_count <= 2'd0;
                end

                STATE_C: begin
                    // Shift in new x sample at every clock
                    x_shift <= {x_shift[1:0], x};
                    f <= 1'b0;
                    g <= 1'b0;
                    y_count <= 2'd0;
                end

                STATE_D: begin
                    // g=1 pulse one cycle
                    f <= 1'b0;
                    g <= 1'b1;
                    // keep x_shift and y_count stable
                    x_shift <= x_shift;
                    y_count <= 2'd0;
                end

                STATE_E: begin
                    // Hold g=1 while monitoring y
                    f <= 1'b0;
                    g <= 1'b1;
                    x_shift <= x_shift;
                    y_count <= y_count + 1'b1;
                end

                STATE_F: begin
                    // Permanent g=1 state
                    f <= 1'b0;
                    g <= 1'b1;
                    x_shift <= x_shift;
                    y_count <= y_count;
                end

                STATE_G: begin
                    // Permanent g=0 state
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= x_shift;
                    y_count <= y_count;
                end

                default: begin
                    // Safe default, should not occur
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;

        case (state)
            STATE_A: begin
                // Wait until resetn released
                if (resetn)
                    next_state = STATE_B;
            end

            STATE_B: begin
                // One cycle f=1 pulse done, move to monitoring x pattern
                next_state = STATE_C;
            end

            STATE_C: begin
                // Monitor x for pattern 1-0-1 (oldest bit x_shift[2], newest x_shift[0])
                // Only start checking after 3 samples collected, i.e. ignore first two cycles by pattern matching condition x_shift valid length.
                // Here, we assume pattern match only if x_shift bits are meaningful:
                // Since x_shift shifts every cycle and is initialized 0, pattern matches only if x_shift == 3'b101.

                if (x_shift == 3'b101)
                    next_state = STATE_D;
                else
                    next_state = STATE_C;
            end

            STATE_D: begin
                // One cycle g=1 pulse done, move to monitor y input
                next_state = STATE_E;
            end

            STATE_E: begin
                // Monitor y for up to 2 cycles, while g=1
                if (y == 1'b1)
                    next_state = STATE_F; // permanent g=1
                else if (y_count == 2'd1) 
                    // y_count counts cycles AFTER first increment in always block,
                    // so at y_count==1 means 2 cycles elapsed (counts 0 and 1),
                    // move to permanent g=0 if no y=1 detected
                    next_state = STATE_G;
                else
                    next_state = STATE_E;
            end

            STATE_F: begin
                // Permanent g=1 until reset
                next_state = STATE_F;
            end

            STATE_G: begin
                // Permanent g=0 until reset
                next_state = STATE_G;
            end

            default: next_state = STATE_A;
        endcase
    end

endmodule