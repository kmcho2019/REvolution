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

// Define the states of the FSM
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE
} state, next_state;

// Detect the pattern '1101'
logic [3:0] shift_register;
logic pattern_detected;

always_ff @(posedge clk) begin
    if (reset) begin
        shift_register <= 4'b0000;
    end else begin
        shift_register <= {shift_register[2:0], data};
    end
end

assign pattern_detected = (shift_register == 4'b1101);

// Implement the FSM
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case(state)
        IDLE: begin
            if (pattern_detected) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_ena_cnt == 4) begin
                next_state = COUNT;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNT;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Count the number of clock cycles in the SHIFT state
logic [1:0] shift_ena_cnt;
always_ff @(posedge clk) begin
    if (reset || state != SHIFT) begin
        shift_ena_cnt <= 2'b00;
    end else if (state == SHIFT) begin
        shift_ena_cnt <= shift_ena_cnt + 1;
    end
end

// Assign outputs
assign shift_ena = (state == SHIFT);
assign counting = (state == COUNT);
assign done = (state == DONE);

endmodule