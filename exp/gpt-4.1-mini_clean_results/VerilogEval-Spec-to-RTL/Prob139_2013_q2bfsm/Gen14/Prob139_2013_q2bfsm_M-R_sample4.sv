module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // State encoding using localparams for clarity
    localparam [2:0]
        S_RESET       = 3'd0,
        S_F_PULSE     = 3'd1,
        S_PATTERN_WAIT= 3'd2,
        S_G_PULSE     = 3'd3,
        S_Y_MONITOR   = 3'd4,
        S_G_ON        = 3'd5,
        S_G_OFF       = 3'd6;

    reg [2:0] state, next_state;

    // Shift register to hold last three x samples
    reg [2:0] x_shift;

    // Counter for monitoring y in Y_MONITOR state (counts 0,1, stops at 2)
    reg [1:0] y_count, next_y_count;

    // Sequential block: state, x_shift, y_count update on clock with synchronous reset
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= S_RESET;
            x_shift <= 3'b000;
            y_count <= 2'd0;
        end else begin
            state   <= next_state;
            x_shift <= {x_shift[1:0], x};
            y_count <= next_y_count;
        end
    end

    // Next state and y_count logic combinational
    always @(*) begin
        // Defaults
        next_state   = state;
        next_y_count = y_count;

        case(state)
            S_RESET: begin
                // Stay in reset until resetn deasserted
                if (resetn)
                    next_state = S_F_PULSE;
                else
                    next_state = S_RESET;

                next_y_count = 2'd0;
            end

            S_F_PULSE: begin
                // One cycle f=1 pulse, then move to pattern wait
                next_state   = S_PATTERN_WAIT;
                next_y_count = 2'd0;
            end

            S_PATTERN_WAIT: begin
                // Wait for pattern 101 in x_shift (which now includes current x)
                // x_shift is updated on posedge, so pattern detected here means last 3 clocks
                
                if (x_shift == 3'b101)
                    next_state = S_G_PULSE;
                else
                    next_state = S_PATTERN_WAIT;

                next_y_count = 2'd0;
            end

            S_G_PULSE: begin
                // One cycle g=1 pulse, then monitor y for up to 2 cycles
                next_state   = S_Y_MONITOR;
                next_y_count = 2'd0;
            end

            S_Y_MONITOR: begin
                // If y==1 within 2 cycles, go to G_ON else after 2 cycles to G_OFF
                if (y == 1'b1) begin
                    next_state   = S_G_ON;
                    next_y_count = 2'd0;
                end else if (y_count == 2'd1) begin
                    // 2 clock cycles passed (counts 0 and 1), y not detected
                    next_state   = S_G_OFF;
                    next_y_count = 2'd0;
                end else begin
                    // Increment counter and remain monitoring
                    next_state   = S_Y_MONITOR;
                    next_y_count = y_count + 1'b1;
                end
            end

            S_G_ON: begin
                // Hold g=1 permanently until reset
                next_state   = S_G_ON;
                next_y_count = 2'd0;
            end

            S_G_OFF: begin
                // Hold g=0 permanently until reset
                next_state   = S_G_OFF;
                next_y_count = 2'd0;
            end

            default: begin
                next_state   = S_RESET;
                next_y_count = 2'd0;
            end
        endcase
    end

    // Outputs depend only on current state (Moore FSM)
    assign f = (state == S_F_PULSE);
    assign g = (state == S_G_PULSE) || (state == S_Y_MONITOR) || (state == S_G_ON);

endmodule