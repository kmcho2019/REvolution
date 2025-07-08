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

    // State encoding
    typedef enum logic [1:0] {
        IDLE     = 2'b00,
        SHIFT    = 2'b01,
        COUNTING = 2'b10,
        DONE     = 2'b11
    } state_t;

    state_t state, next_state;

    // 4-bit shift register for pattern detection
    reg [3:0] shift_reg;

    // 2-bit counter for 4 shift cycles
    reg [1:0] shift_cnt;

    // Pattern to detect: 1101 (binary)
    localparam [3:0] PATTERN = 4'b1101;

    // Sequential logic: state, shift_reg, shift_cnt update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0000;
            shift_cnt <= 2'b00;
        end else begin
            state <= next_state;

            if (state == IDLE) begin
                // Shift in data bit to detect pattern
                shift_reg <= {shift_reg[2:0], data};
                shift_cnt <= 2'b00; // reset shift counter in IDLE
            end else if (state == SHIFT) begin
                // Shift in data during SHIFT state as well (assumed for counters)
                shift_reg <= {shift_reg[2:0], data};
                shift_cnt <= shift_cnt + 1'b1;
            end else begin
                // In other states, no shift or shift_cnt change
                shift_reg <= shift_reg;
                shift_cnt <= 2'b00;
            end
        end
    end

    // Next state and output logic
    always @(*) begin
        // Default outputs
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;
        next_state = state;

        case (state)
            IDLE: begin
                // Stay in IDLE until pattern detected
                if (shift_reg == PATTERN)
                    next_state = SHIFT;
            end

            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_cnt == 2'd3) // after 4 cycles (0..3)
                    next_state = COUNTING;
            end

            COUNTING: begin
                counting = 1'b1;
                if (done_counting)
                    next_state = DONE;
            end

            DONE: begin
                done = 1'b1;
                if (ack)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule