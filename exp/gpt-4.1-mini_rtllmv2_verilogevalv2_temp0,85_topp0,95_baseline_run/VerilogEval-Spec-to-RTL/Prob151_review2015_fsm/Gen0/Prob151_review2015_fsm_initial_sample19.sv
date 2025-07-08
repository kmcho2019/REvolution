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

    // FSM States
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        SHIFT = 2'b01,
        COUNT = 2'b10,
        DONE  = 2'b11
    } state_t;

    state_t state, next_state;

    // Shift register to detect pattern 1101
    reg [3:0] pattern_shift;

    // Counter for 4 cycles in SHIFT state
    reg [2:0] shift_count; // 3 bits to hold count up to 4

    // Pattern to detect
    localparam [3:0] START_PATTERN = 4'b1101;

    // Sequential logic: state and pattern_shift registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            shift_count <= 3'd0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // In IDLE, shift in data to pattern_shift
            if (state == IDLE) begin
                pattern_shift <= {pattern_shift[2:0], data};
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
                shift_count <= 3'd0;
            end

            // SHIFT state: assert shift_ena and count 4 cycles
            else if (state == SHIFT) begin
                shift_ena <= 1'b1;
                counting <= 1'b0;
                done <= 1'b0;
                shift_count <= shift_count + 3'd1;
            end

            // COUNT state: assert counting, wait for done_counting
            else if (state == COUNT) begin
                shift_ena <= 1'b0;
                counting <= 1'b1;
                done <= 1'b0;
                shift_count <= 3'd0;
            end

            // DONE state: assert done, wait for ack
            else if (state == DONE) begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b1;
                shift_count <= 3'd0;
            end

            else begin
                // default clear outputs
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
                shift_count <= 3'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Look for pattern 1101
                if (pattern_shift == START_PATTERN)
                    next_state = SHIFT;
            end

            SHIFT: begin
                if (shift_count == 3'd4) // after 4 cycles
                    next_state = COUNT;
            end

            COUNT: begin
                if (done_counting)
                    next_state = DONE;
            end

            DONE: begin
                if (ack)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule