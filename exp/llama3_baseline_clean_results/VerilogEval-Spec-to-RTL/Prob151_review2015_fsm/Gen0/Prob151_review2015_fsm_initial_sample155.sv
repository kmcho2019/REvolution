module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

// Enum for states
enum logic [2:0] {
    IDLE = 3'b001,
    SHIFT = 3'b010,
    COUNTING = 3'b011,
    DONE_WAIT = 3'b100
} state, next_state;

// Pattern detection
logic [3:0] pattern_reg;
logic pattern_detected;

// Shift counter
logic [1:0] shift_counter;

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (pattern_detected) begin
                next_state = SHIFT;
            end
        end
        SHIFT: begin
            if (shift_counter == 4'd3) begin
                next_state = COUNTING;
            end
        end
        COUNTING: begin
            if (done_counting) begin
                next_state = DONE_WAIT;
            end
        end
        DONE_WAIT: begin
            if (ack) begin
                next_state = IDLE;
            end
        end
    endcase
end

// Pattern detection logic
always_ff @(posedge clk) begin
    if (reset) begin
        pattern_reg <= 4'b0000;
    end else begin
        pattern_reg <= {pattern_reg[2:0], data};
    end
end

assign pattern_detected = (pattern_reg == 4'b1101);

// Shift counter logic
always_ff @(posedge clk) begin
    if (state == IDLE || state == COUNTING || state == DONE_WAIT) begin
        shift_counter <= 4'd0;
    end else if (state == SHIFT) begin
        shift_counter <= shift_counter + 1'b1;
    end
end

// Output logic
assign shift_ena = (state == SHIFT);
assign counting = (state == COUNTING);
assign done = (state == DONE_WAIT);

endmodule