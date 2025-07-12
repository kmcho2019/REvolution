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

    state_t state, next_state;

    reg [2:0] x_shift;
    reg [1:0] y_count; // count up to 2 cycles in WAIT_Y

    always @(posedge clk) begin
        if (!resetn) begin
            // synchronous reset: enter RESET state, clear outputs and registers
            state   <= RESET;
            f       <= 1'b0;
            g       <= 1'b0;
            x_shift <= 3'b000;
            y_count <= 2'd0;
        end else begin
            state <= next_state;

            case (state)
                RESET: begin
                    // stay here while reset is asserted
                    f       <= 1'b0;
                    g       <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end
                PULSE_F: begin
                    // pulse f for one clock cycle
                    f       <= 1'b1;
                    g       <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end
                WAIT_X: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    // shift in new x sample, oldest in MSB, newest in LSB
                    x_shift <= {x_shift[1:0], x};
                    y_count <= 2'd0;
                end
                PULSE_G: begin
                    // pulse g for one cycle
                    f       <= 1'b0;
                    g       <= 1'b1;
                    // keep x_shift and y_count unchanged (not needed here)
                end
                WAIT_Y: begin
                    f <= 1'b0;
                    // hold g=1 during wait
                    g <= 1'b1;

                    // if y=1 detected within 2 cycles, move to HOLD_G1 else after 2 cycles to HOLD_G0
                    y_count <= y_count + 1'b1;
                end
                HOLD_G1: begin
                    f <= 1'b0;
                    g <= 1'b1; // hold g=1 permanently
                end
                HOLD_G0: begin
                    f <= 1'b0;
                    g <= 1'b0; // hold g=0 permanently
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end
            endcase
        end
    end

    // Next state logic
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
                // one cycle pulse done, move to waiting for pattern on x
                next_state = WAIT_X;
            end
            WAIT_X: begin
                // check if pattern 1,0,1 detected on x_shift (oldest at MSB)
                if (x_shift == 3'b101)
                    next_state = PULSE_G;
                else if (!resetn)
                    next_state = RESET;
                else
                    next_state = WAIT_X;
            end
            PULSE_G: begin
                // pulse g done, start waiting for y input
                next_state = WAIT_Y;
            end
            WAIT_Y: begin
                if (!resetn) begin
                    next_state = RESET;
                end else if (y == 1'b1) begin
                    next_state = HOLD_G1;
                end else if (y_count == 2'd2) begin
                    // y not detected within 2 cycles
                    next_state = HOLD_G0;
                end else begin
                    next_state = WAIT_Y;
                end
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