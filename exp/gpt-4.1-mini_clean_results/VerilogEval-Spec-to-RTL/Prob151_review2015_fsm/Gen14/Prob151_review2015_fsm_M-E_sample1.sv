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

    // Define FSM states (2 bits)
    typedef enum logic [1:0] {
        IDLE       = 2'b00,
        SHIFT      = 2'b01,
        COUNT_WAIT = 2'b10,
        DONE_WAIT  = 2'b11
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;      // To detect the start pattern 1101
    reg [2:0] shift_counter;  // Counts 4 cycles during SHIFT state (0 to 3)

    // Next state logic and outputs combinational
    always @(*) begin
        next_state = state;

        // Default outputs
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case (state)
            IDLE: begin
                // Wait for start pattern (1101)
                if (shift_reg == 4'b1101) begin
                    next_state = SHIFT;
                end
            end

            SHIFT: begin
                // Enable shifting for 4 cycles
                shift_ena = 1'b1;
                if (shift_counter == 3'd3) begin
                    next_state = COUNT_WAIT;
                end
            end

            COUNT_WAIT: begin
                counting = 1'b1;
                if (done_counting) begin
                    next_state = DONE_WAIT;
                end
            end

            DONE_WAIT: begin
                done = 1'b1;
                if (ack) begin
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0000;
            shift_counter <= 3'd0;
        end else begin
            state <= next_state;

            // Shift in new data bit into shift_reg only in IDLE and SHIFT states
            // In IDLE, continuously shift to detect pattern
            // In SHIFT, shift in bits as duration to delay
            if (state == IDLE || state == SHIFT) begin
                shift_reg <= {shift_reg[2:0], data};
            end else begin
                // No new bits needed in COUNT_WAIT or DONE_WAIT
                shift_reg <= shift_reg;
            end

            // Manage shift_counter only in SHIFT state
            if (state == SHIFT) begin
                shift_counter <= shift_counter + 3'd1;
            end else begin
                shift_counter <= 3'd0;
            end
        end
    end

endmodule