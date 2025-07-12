module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    // One-hot state encoding
    localparam IDLE   = 4'b0001,
               SHIFT  = 4'b0010,
               COUNT  = 4'b0100,
               DONE   = 4'b1000;

    reg [3:0] state, next_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift_reg;

    // Shift counter for exactly 4 shift cycles
    reg [1:0] shift_counter;

    // State register and shift counter with synchronous active high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift_reg <= 4'b0000;
            shift_counter <= 2'd0;
        end else begin
            state <= next_state;
            // Shift in new data bit every cycle for pattern detection only in IDLE
            if (state == IDLE) begin
                pattern_shift_reg <= {pattern_shift_reg[2:0], data};
            end else begin
                // No shifting pattern_shift_reg in other states, hold value
                pattern_shift_reg <= pattern_shift_reg;
            end

            // Increment shift_counter only in SHIFT state, else reset to 0
            if (state == SHIFT)
                shift_counter <= shift_counter + 2'd1;
            else
                shift_counter <= 2'd0;
        end
    end

    // Next state logic - one-hot FSM
    always @(*) begin
        next_state = state; // default hold

        case(state)
            IDLE: begin
                // If pattern 1101 detected on pattern_shift_reg, move to SHIFT
                if (pattern_shift_reg == 4'b1101)
                    next_state = SHIFT;
            end

            SHIFT: begin
                // After 4 cycles of shift_ena, move to COUNT
                if (shift_counter == 2'd3)
                    next_state = COUNT;
            end

            COUNT: begin
                // Wait until done_counting is asserted to move to DONE
                if (done_counting)
                    next_state = DONE;
            end

            DONE: begin
                // Wait for ack to return to IDLE and restart pattern detection
                if (ack)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Outputs: Moore outputs based on current state
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule