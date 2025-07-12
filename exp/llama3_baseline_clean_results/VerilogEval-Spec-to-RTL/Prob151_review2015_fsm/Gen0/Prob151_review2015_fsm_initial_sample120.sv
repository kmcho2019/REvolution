module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

// Enumerate states
typedef enum logic [2:0] {
    IDLE = 3'b001,
    SHIFT = 3'b010,
    COUNT = 3'b011,
    DONE_WAIT = 3'b100
} state_t;

// Current state register
state_t state, next_state;

// Sequence counter (for the 1101 pattern)
logic [3:0] seq_cnt;

// Bit counter (for the 4 bits to be shifted in)
logic [1:0] bit_cnt;

// Shift enable and done output
assign shift_ena = (state == SHIFT);
assign counting = (state == COUNT);
assign done = (state == DONE_WAIT);

// State machine
always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            // Look for the start pattern 1101
            if (data) begin
                seq_cnt = seq_cnt + 1;
                if (seq_cnt == 4) next_state = SHIFT;
            end else begin
                seq_cnt = 0;
            end
        end
        SHIFT: begin
            // Shift in 4 more bits to determine the duration
            bit_cnt = bit_cnt + 1;
            if (bit_cnt == 4) begin
                bit_cnt = 0;
                next_state = COUNT;
            end
        end
        COUNT: begin
            // Wait for the counters to finish counting
            if (done_counting) next_state = DONE_WAIT;
        end
        DONE_WAIT: begin
            // Notify the user and wait for acknowledgement
            if (ack) next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// State and counter registers
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        seq_cnt <= 0;
        bit_cnt <= 0;
    end else begin
        state <= next_state;
        if (state == IDLE) seq_cnt <= 0;
        if (state == SHIFT) bit_cnt <= bit_cnt + 1;
    end
end

endmodule