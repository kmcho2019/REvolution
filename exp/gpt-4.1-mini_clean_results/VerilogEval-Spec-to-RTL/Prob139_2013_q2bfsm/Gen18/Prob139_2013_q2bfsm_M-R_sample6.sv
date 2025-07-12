module TopModule (
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // One-hot state encoding for clarity
    localparam A_F_PULSE  = 4'b0001; // initial state: pulse f one cycle
    localparam B_WAIT_X   = 4'b0010; // wait for x pattern 1,0,1
    localparam C_G_PULSE  = 4'b0100; // pulse g one cycle
    localparam D_Y_WAIT   = 4'b1000; // wait up to 2 cycles for y=1

    reg [3:0] state, next_state;

    // Shift register for x pattern detection
    reg [2:0] x_shift;

    // 2-cycle timer for y monitoring
    reg [1:0] y_counter;

    // Flag to indicate g permanent hold (1=hold g=1, 0=hold g=0)
    reg g_permanent;

    // Sequential logic for state, outputs, counters
    always @(posedge clk) begin
        if (!resetn) begin
            // synchronous active low reset
            state       <= A_F_PULSE;
            f           <= 1'b0;
            g           <= 1'b0;
            x_shift     <= 3'b000;
            y_counter   <= 2'd0;
            g_permanent <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                A_F_PULSE: begin
                    f <= 1'b1;    // pulse f for one cycle
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_counter <= 2'd0;
                    g_permanent <= 1'b0;
                end
                B_WAIT_X: begin
                    f <= 1'b0;
                    g <= g_permanent ? 1'b1 : 1'b0;
                    // shift in x sample: oldest bit at MSB, newest at LSB
                    x_shift <= {x_shift[1:0], x};
                    // y_counter and g_permanent unchanged here
                end
                C_G_PULSE: begin
                    f <= 1'b0;
                    g <= 1'b1;    // pulse g for one cycle
                    // reset y_counter to 0 before y wait start
                    y_counter <= 2'd0;
                    g_permanent <= 1'b0; // not permanent yet
                    // x_shift unchanged
                end
                D_Y_WAIT: begin
                    f <= 1'b0;
                    // If g_permanent already set, hold g=1 forever
                    if (g_permanent) begin
                        g <= 1'b1;
                        y_counter <= y_counter; // no change
                    end else begin
                        // during waiting period
                        if (y == 1'b1) begin
                            g_permanent <= 1'b1;
                            g <= 1'b1;
                            // hold y_counter as is (optional)
                            y_counter <= y_counter;
                        end else if (y_counter == 2'd1) begin
                            // waited two cycles, no y=1, latch g=0 permanently
                            g_permanent <= 1'b0;
                            g <= 1'b0;
                            y_counter <= y_counter; // hold counter
                        end else begin
                            // increment counter and keep g=1 while waiting
                            g <= 1'b1;
                            y_counter <= y_counter + 1'b1;
                            g_permanent <= 1'b0;
                        end
                    end
                end
                default: begin
                    // Fallback: reset outputs and state
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_counter <= 2'd0;
                    g_permanent <= 1'b0;
                end
            endcase
        end
    end

    // Combinational logic for next state
    always @(*) begin
        next_state = state;
        case(state)
            A_F_PULSE: begin
                // after one cycle pulse f, start monitoring x
                next_state = B_WAIT_X;
            end
            B_WAIT_X: begin
                // check for pattern 1,0,1 in x_shift (MSB oldest)
                // pattern: x_shift[2]=1, x_shift[1]=0, x_shift[0]=1
                if (x_shift == 3'b101) begin
                    next_state = C_G_PULSE;
                end else begin
                    next_state = B_WAIT_X;
                end
            end
            C_G_PULSE: begin
                // after one cycle pulse g, start y monitoring
                next_state = D_Y_WAIT;
            end
            D_Y_WAIT: begin
                if (g_permanent) begin
                    // Once g_permanent=1, stay here indefinitely
                    next_state = D_Y_WAIT;
                end else if ((y == 1'b1)) begin
                    // y detected, hold g=1 permanently and stay
                    next_state = D_Y_WAIT;
                end else if (y_counter == 2'd1) begin
                    // 2 cycles elapsed, no y=1, hold g=0 permanently
                    next_state = D_Y_WAIT;
                end else begin
                    // still waiting for y input
                    next_state = D_Y_WAIT;
                end
            end
            default: begin
                next_state = A_F_PULSE;
            end
        endcase
    end

endmodule