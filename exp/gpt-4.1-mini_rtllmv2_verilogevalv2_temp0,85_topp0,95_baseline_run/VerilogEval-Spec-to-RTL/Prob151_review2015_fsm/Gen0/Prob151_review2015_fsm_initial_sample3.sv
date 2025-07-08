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

    // FSM state encoding
    typedef enum logic [1:0] {
        IDLE  = 2'd0,
        SHIFT = 2'd1,
        COUNT = 2'd2,
        DONE  = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift register to detect pattern 1101 (4 bits)
    reg [3:0] pattern_shift;

    // Counter for 4 shift cycles
    reg [2:0] shift_count; // 3 bits for counting up to 4

    // Detect pattern 1101
    wire pattern_detected = (pattern_shift == 4'b1101);

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Shift in data to detect pattern
                    pattern_shift <= {pattern_shift[2:0], data};
                    shift_count <= 3'd0;
                end

                SHIFT: begin
                    // Keep shifting (this FSM only enables shift_ena, actual data path shifts)
                    // Count the number of shift cycles
                    shift_count <= shift_count + 1'b1;
                end

                COUNT: begin
                    // No pattern shifting or counting shifts here
                end

                DONE: begin
                    // No pattern shifting or counting shifts here
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case(state)
            IDLE: begin
                // Wait for pattern 1101
                if (pattern_detected) begin
                    next_state = SHIFT;
                end
            end

            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_count == 3'd3) begin
                    // After 4 cycles (0..3), go to COUNT
                    next_state = COUNT;
                end
            end

            COUNT: begin
                counting = 1'b1;
                if (done_counting) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                done = 1'b1;
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule