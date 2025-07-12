module TopModule (
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // FSM state encoding
    typedef enum reg [1:0] {
        S_F_PULSE = 2'd0, // pulse f for 1 cycle after reset
        S_WAIT_X  = 2'd1, // monitor x input for pattern 1,0,1
        S_G_PULSE = 2'd2, // pulse g for 1 cycle after pattern detected
        S_Y_WAIT  = 2'd3  // wait up to 2 cycles for y=1, then hold g accordingly
    } state_t;

    state_t state, next_state;

    reg [2:0] x_shift;     // shift register for x samples
    reg [1:0] y_timer;     // counts cycles for y monitoring
    reg       g_permanent; // flag: 1 = keep g=1 permanently; 0 = keep g=0 permanently

    always @(posedge clk) begin
        if (!resetn) begin
            // synchronous active low reset
            state       <= S_F_PULSE;
            f           <= 1'b0;
            g           <= 1'b0;
            g_permanent <= 1'b0;
            x_shift     <= 3'b000;
            y_timer     <= 2'd0;
        end else begin
            state <= next_state;

            case (state)
                S_F_PULSE: begin
                    // Pulse f=1 for one cycle
                    f <= 1'b1;
                    g <= 1'b0;
                    g_permanent <= 1'b0;
                    x_shift <= 3'b000;
                    y_timer <= 2'd0;
                end
                S_WAIT_X: begin
                    f <= 1'b0;

                    // shift in x, oldest at MSB, newest at LSB
                    x_shift <= {x_shift[1:0], x};

                    // g stays at 0 here
                    if (!g_permanent)
                        g <= 1'b0;
                    else
                        g <= 1'b1;
                end
                S_G_PULSE: begin
                    // pulse g=1 for one cycle
                    f <= 1'b0;
                    g <= 1'b1;
                    g_permanent <= 1'b0;
                    y_timer <= 2'd0;
                end
                S_Y_WAIT: begin
                    f <= 1'b0;
                    if (g_permanent) begin
                        g <= 1'b1; // keep g on permanently
                        y_timer <= y_timer;
                    end else begin
                        // g either still on (pulse) or off (decide now)
                        if (y == 1'b1) begin
                            // y detected, keep g=1 permanently
                            g <= 1'b1;
                            g_permanent <= 1'b1;
                            y_timer <= y_timer;
                        end else if (y_timer == 2'd1) begin
                            // 2 cycles elapsed without y=1, keep g=0 permanently
                            g <= 1'b0;
                            g_permanent <= 1'b0;
                            y_timer <= 2'd2; // indicate finished
                        end else begin
                            // increment timer, keep g=1 during waiting
                            g <= 1'b1;
                            y_timer <= y_timer + 1'b1;
                        end
                    end
                    // f remains 0 here
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    g_permanent <= 1'b0;
                    x_shift <= 3'b000;
                    y_timer <= 2'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            S_F_PULSE: begin
                // after one cycle pulse of f, go to monitoring x
                next_state = S_WAIT_X;
            end
            S_WAIT_X: begin
                // Check for x pattern 1,0,1 in last 3 bits
                if (x_shift == 3'b101)
                    next_state = S_G_PULSE;
                else
                    next_state = S_WAIT_X;
            end
            S_G_PULSE: begin
                // after one cycle pulse of g, start y monitoring
                next_state = S_Y_WAIT;
            end
            S_Y_WAIT: begin
                if (g_permanent) begin
                    // hold g=1 permanently
                    next_state = S_Y_WAIT;
                end else if (y == 1'b1) begin
                    // detected y=1, hold g=1 permanently
                    next_state = S_Y_WAIT;
                end else if (y_timer == 2'd1) begin
                    // 2 cycles elapsed without y=1, hold g=0 permanently
                    next_state = S_Y_WAIT;
                end else begin
                    // still waiting for y
                    next_state = S_Y_WAIT;
                end
            end
            default: begin
                next_state = S_F_PULSE;
            end
        endcase
    end

endmodule