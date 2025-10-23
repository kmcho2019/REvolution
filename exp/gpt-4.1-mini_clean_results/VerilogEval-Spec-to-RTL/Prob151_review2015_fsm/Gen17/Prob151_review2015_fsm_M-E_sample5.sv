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

    // States: IDLE - searching pattern, SHIFT - shifting 4 bits, WAIT_COUNT - waiting counting done, DONE - waiting ack
    typedef enum logic [1:0] {
        IDLE       = 2'd0,
        SHIFT      = 2'd1,
        WAIT_COUNT = 2'd2,
        DONE_STATE = 2'd3
    } state_t;

    state_t state, next_state;

    // 4-bit shift register to track last 4 data bits for pattern detection
    reg [3:0] data_shift_reg, next_data_shift_reg;

    // 2-bit counter for shift cycles (0 to 3)
    reg [1:0] shift_counter, next_shift_counter;

    // Pattern to detect: 4'b1101
    localparam [3:0] PATTERN = 4'b1101;

    // Next state logic and registers
    always @(posedge clk) begin
        if (reset) begin
            state           <= IDLE;
            data_shift_reg  <= 4'b0000;
            shift_counter   <= 2'd0;
        end else begin
            state           <= next_state;
            data_shift_reg  <= next_data_shift_reg;
            shift_counter   <= next_shift_counter;
        end
    end

    // Combinational next-state and outputs logic
    always @(*) begin
        // Default assignments
        next_state          = state;
        next_data_shift_reg = {data_shift_reg[2:0], data}; // shift in new bit
        next_shift_counter  = shift_counter;

        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case (state)
            IDLE: begin
                // Update shift reg with incoming data
                // If pattern detected in data_shift_reg after shifting in new data, start shifting delay bits
                if (next_data_shift_reg == PATTERN) begin
                    next_state         = SHIFT;
                    next_shift_counter = 2'd0;
                    // shift_ena asserted in SHIFT state, not here
                end
                // else remain in IDLE
            end

            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_counter == 2'd3) begin
                    // After 4 shift cycles, move to counting
                    next_state         = WAIT_COUNT;
                    next_shift_counter = 2'd0;
                end else begin
                    next_shift_counter = shift_counter + 1'b1;
                end
                // Continue updating data_shift_reg to keep tracking input data in case pattern detection needed again later (though FSM will not detect in SHIFT)
            end

            WAIT_COUNT: begin
                counting = 1'b1;
                // Keep updating data_shift_reg, but pattern detection disabled
                if (done_counting) begin
                    next_state = DONE_STATE;
                end
            end

            DONE_STATE: begin
                done = 1'b1;
                // Keep updating shift register to remain synchronized
                if (ack) begin
                    next_state = IDLE;
                    // On ack, reset pattern detection shift reg for fresh start (could zero it)
                    next_data_shift_reg = 4'b0000;
                end
            end

            default: begin
                next_state         = IDLE;
                next_data_shift_reg = 4'b0000;
                next_shift_counter  = 2'd0;
            end
        endcase
    end

endmodule