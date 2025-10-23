module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE     = 2'b00,
        SHIFT    = 2'b01,
        COUNTING = 2'b10,
        DONE     = 2'b11
    } state_t;
    state_t state, next_state;

    reg [3:0] shift_reg;    // To detect pattern 1101
    reg [2:0] shift_count;  // To count 4 shift cycles

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0000;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;

            if(state == IDLE) begin
                // Shift in serial data to detect pattern
                shift_reg <= {shift_reg[2:0], data};
            end else if (state == SHIFT) begin
                shift_count <= shift_count + 1;
            end else begin
                shift_count <= 3'd0;
            end
        end
    end

    // Next state logic and outputs
    always @(*) begin
        // Default outputs
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;
        next_state = state;

        case(state)
            IDLE: begin
                // Wait for pattern 1101 (binary 4'b1101)
                if (shift_reg == 4'b1101) begin
                    next_state = SHIFT;
                end
            end

            SHIFT: begin
                // Enable shifting for exactly 4 clocks
                shift_ena = 1'b1;

                if (shift_count == 3'd3) begin
                    next_state = COUNTING;
                end
            end

            COUNTING: begin
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

            default: next_state = IDLE;
        endcase
    end

endmodule