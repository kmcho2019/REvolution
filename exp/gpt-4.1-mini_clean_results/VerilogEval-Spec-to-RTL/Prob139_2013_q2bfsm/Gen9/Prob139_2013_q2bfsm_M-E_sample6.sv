module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    typedef enum logic [2:0] {
        S0        = 3'd0, // Reset state
        S1        = 3'd1, // Assert f=1 one cycle
        S2        = 3'd2, // Shift in x, detect pattern 101
        MONITOR_Y = 3'd3, // g=1, monitor y for 2 cycles
        G_ON      = 3'd4, // g=1 permanently
        G_OFF     = 3'd5  // g=0 permanently
    } state_t;

    state_t state, next_state;

    reg [2:0] pattern_reg;   // To track last 3 x inputs
    reg [1:0] y_timer;       // Count cycles monitoring y

    // Sequential logic: state, outputs, pattern_reg, y_timer
    always @(posedge clk) begin
        if (!resetn) begin
            state       <= S0;
            f           <= 1'b0;
            g           <= 1'b0;
            pattern_reg <= 3'b000;
            y_timer     <= 2'd0;
        end else begin
            state <= next_state;

            case (state)
                S0: begin
                    // Outputs cleared at reset
                    f <= 1'b0;
                    g <= 1'b0;
                    pattern_reg <= 3'b000;
                    y_timer <= 2'd0;
                end
                S1: begin
                    // Assert f=1 for this cycle
                    f <= 1'b1;
                    g <= 1'b0;
                    // pattern_reg unchanged
                    y_timer <= 2'd0;
                end
                S2: begin
                    // f=0 after pulse
                    f <= 1'b0;

                    // Shift in x input into pattern_reg
                    // pattern_reg[2] is oldest, pattern_reg[0] newest
                    pattern_reg <= {pattern_reg[1:0], x};

                    // g=0 until pattern detected
                    g <= 1'b0;

                    y_timer <= 2'd0;
                end
                MONITOR_Y: begin
                    f <= 1'b0;
                    g <= 1'b1;

                    // Increment y_timer, max 2 cycles
                    if (y_timer < 2'd2)
                        y_timer <= y_timer + 1'b1;
                    else
                        y_timer <= y_timer;

                    pattern_reg <= pattern_reg; // Hold pattern_reg
                end
                G_ON: begin
                    // Permanent g=1, f=0
                    f <= 1'b0;
                    g <= 1'b1;
                    pattern_reg <= pattern_reg;
                    y_timer <= y_timer;
                end
                G_OFF: begin
                    // Permanent g=0, f=0
                    f <= 1'b0;
                    g <= 1'b0;
                    pattern_reg <= pattern_reg;
                    y_timer <= y_timer;
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    pattern_reg <= 3'b000;
                    y_timer <= 2'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // Default hold

        case (state)
            S0: begin
                if (resetn)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                // After one cycle asserting f=1, move to S2
                next_state = S2;
            end

            S2: begin
                // Check if pattern_reg has matched 3'b101
                // Only start pattern check after at least 3 bits collected
                if (pattern_reg == 3'b101)
                    next_state = MONITOR_Y;
                else
                    next_state = S2; // keep shifting in x each cycle
            end

            MONITOR_Y: begin
                // If y=1 at any time in monitoring, go G_ON
                if (y == 1'b1)
                    next_state = G_ON;
                // Else if timer expired (2 cycles done) and y not seen, go G_OFF
                else if (y_timer >= 2'd2)
                    next_state = G_OFF;
                else
                    next_state = MONITOR_Y;
            end

            G_ON: begin
                // Stay permanently
                next_state = G_ON;
            end

            G_OFF: begin
                // Stay permanently
                next_state = G_OFF;
            end

            default: next_state = S0;
        endcase
    end

endmodule