module TopModule (
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    typedef enum reg [2:0] {
        RESET       = 3'd0, // state A - on reset asserted
        PULSE_F     = 3'd1, // pulse f=1 one cycle after reset deasserted
        WAIT_X      = 3'd2, // wait for x pattern 1,0,1
        PULSE_G     = 3'd3, // pulse g=1 one cycle after pattern detected
        WAIT_Y      = 3'd4, // wait up to 2 cycles for y=1, then hold g accordingly
        HOLD_G1     = 3'd5, // hold g=1 permanently until reset
        HOLD_G0     = 3'd6  // hold g=0 permanently until reset
    } state_t;

    reg [2:0] state, next_state;
    reg [2:0] x_shift;    // shift register to detect x pattern
    reg [1:0] y_count;    // counts cycles waiting for y=1 (max 2)

    // Sequential logic: state and registers update
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= RESET;
            f       <= 1'b0;
            g       <= 1'b0;
            x_shift <= 3'b000;
            y_count <= 2'd0;
        end else begin
            state <= next_state;

            case (state)
                RESET: begin
                    f       <= 1'b0;
                    g       <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end

                PULSE_F: begin
                    // pulse f for one cycle exactly
                    f       <= 1'b1;
                    g       <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end

                WAIT_X: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    // Shift x into x_shift (oldest MSB, newest LSB)
                    x_shift <= {x_shift[1:0], x};
                    y_count <= 2'd0;
                end

                PULSE_G: begin
                    // pulse g for one cycle exactly
                    f <= 1'b0;
                    g <= 1'b1;
                    // Preserve x_shift and y_count unchanged (not needed)
                end

                WAIT_Y: begin
                    f <= 1'b0;
                    g <= 1'b1; // hold g=1 while waiting for y

                    // Increment y_count only if less than 1 (to get exactly 2 cycles wait)
                    if (y_count < 2'd1)
                        y_count <= y_count + 1'b1;
                    else
                        y_count <= y_count; // hold max count
                    // x_shift not used here, no update
                end

                HOLD_G1: begin
                    f <= 1'b0;
                    g <= 1'b1; // permanently hold g=1 until reset
                end

                HOLD_G0: begin
                    f <= 1'b0;
                    g <= 1'b0; // permanently hold g=0 until reset
                end

                default: begin
                    f       <= 1'b0;
                    g       <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            RESET: begin
                if (resetn)
                    next_state = PULSE_F;
                else
                    next_state = RESET;
            end

            PULSE_F: begin
                // After pulsing f, go to WAIT_X
                if (!resetn)
                    next_state = RESET;
                else
                    next_state = WAIT_X;
            end

            WAIT_X: begin
                if (!resetn)
                    next_state = RESET;
                else if (x_shift == 3'b101)
                    next_state = PULSE_G;
                else
                    next_state = WAIT_X;
            end

            PULSE_G: begin
                if (!resetn)
                    next_state = RESET;
                else
                    next_state = WAIT_Y;
            end

            WAIT_Y: begin
                if (!resetn)
                    next_state = RESET;
                else if (y == 1'b1)
                    next_state = HOLD_G1;
                else if (y_count == 2'd1)
                    // after 2 cycles waiting (count 0 and 1), no y detected
                    next_state = HOLD_G0;
                else
                    next_state = WAIT_Y;
            end

            HOLD_G1: begin
                if (!resetn)
                    next_state = RESET;
                else
                    next_state = HOLD_G1;
            end

            HOLD_G0: begin
                if (!resetn)
                    next_state = RESET;
                else
                    next_state = HOLD_G0;
            end

            default: next_state = RESET;
        endcase
    end

endmodule