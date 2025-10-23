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

    // FSM states
    typedef enum reg [2:0] {
        IDLE      = 3'd0, // waiting for start pattern
        SHIFT     = 3'd1, // shifting in 4 delay bits
        WAIT_CNT  = 3'd2, // counting in progress
        DONE_WAIT = 3'd3  // done, waiting for ack
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;       // Holds last 4 input bits for pattern detection and shift-in bits
    reg [2:0] shift_counter;   // counts from 0 to 3 during SHIFT state (4 bits shifted in total)

    // Sequential logic: state, shift register and shift_counter updates with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0000;
            shift_counter <= 3'd0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Shift in data into shift_reg every clock cycle in IDLE and SHIFT states
            if (state == IDLE || state == SHIFT) begin
                shift_reg <= {shift_reg[2:0], data};
            end

            // shift_ena and shift_counter logic
            if (next_state == SHIFT && state != SHIFT) begin
                // Transitioning into SHIFT state: enable shift_ena and reset shift_counter
                shift_ena <= 1'b1;
                shift_counter <= 3'd0;
            end else if (state == SHIFT) begin
                // during SHIFT state: keep shift_ena asserted, count number of shifted bits
                shift_ena <= 1'b1;
                shift_counter <= shift_counter + 3'd1;
            end else begin
                shift_ena <= 1'b0;
                shift_counter <= 3'd0;
            end

            // counting output: asserted only in WAIT_CNT state
            counting <= (next_state == WAIT_CNT);

            // done output: asserted only in DONE_WAIT state
            done <= (next_state == DONE_WAIT);
        end
    end

    // Combinational logic: next state determination
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Check if last 4 bits in shift_reg == 4'b1101 (start pattern)
                // If yes, start SHIFT state to shift 4 delay bits
                if (shift_reg == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end

            SHIFT: begin
                // After shifting in 4 bits (shift_counter counts 0..3),
                // move to WAIT_CNT state to wait for counting done
                if (shift_counter == 3'd3)
                    next_state = WAIT_CNT;
                else
                    next_state = SHIFT;
            end

            WAIT_CNT: begin
                // Wait for done_counting to be high, then assert done
                if (done_counting)
                    next_state = DONE_WAIT;
                else
                    next_state = WAIT_CNT;
            end

            DONE_WAIT: begin
                // Wait for ack to go high, then go back to IDLE (pattern detection)
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule