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
        IDLE    = 2'b00,
        SHIFT   = 2'b01,
        COUNT   = 2'b10,
        DONE_ST = 2'b11
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection
    reg [3:0] pattern_shift;

    // Counter for shift cycles (4 cycles)
    reg [2:0] shift_counter;

    // Pattern constant for 1101
    localparam [3:0] PATTERN = 4'b1101;

    // Sequential logic: state, pattern_shift, shift_counter
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            shift_counter <= 3'd0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // Shift pattern register every cycle except during SHIFT state
            if (state == IDLE) begin
                pattern_shift <= {pattern_shift[2:0], data};
            end else if (state == SHIFT) begin
                // shift_ena asserted, increment shift_counter
                shift_counter <= shift_counter + 3'd1;
            end else begin
                shift_counter <= 3'd0;
            end

            // Outputs registered per state
            shift_ena <= (next_state == SHIFT);
            counting <= (next_state == COUNT);
            done <= (next_state == DONE_ST);
        end
    end

    // Combinational next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Detect pattern 1101 on shift register
                if (pattern_shift == PATTERN) begin
                    next_state = SHIFT;
                end else begin
                    next_state = IDLE;
                end
            end
            SHIFT: begin
                // Shift_ena asserted for exactly 4 cycles
                if (shift_counter == 3'd3) begin
                    next_state = COUNT;
                end else begin
                    next_state = SHIFT;
                end
            end
            COUNT: begin
                // Wait until done_counting asserted
                if (done_counting) begin
                    next_state = DONE_ST;
                end else begin
                    next_state = COUNT;
                end
            end
            DONE_ST: begin
                // Wait for ack before returning to IDLE and pattern detection
                if (ack) begin
                    next_state = IDLE;
                end else begin
                    next_state = DONE_ST;
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule