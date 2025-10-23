module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Define the states
enum logic [1:0] {
    IDLE = 2'b00,
    SHIFT = 2'b01,
    COUNTING = 2'b10,
    DONE_WAIT = 2'b11
} state, next_state;

// Shift counter
reg [1:0] shift_counter;
reg [3:0] pattern_detector;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_detector <= 4'b0000;
        shift_counter <= 2'b00;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        state <= next_state;
        pattern_detector <= {data, pattern_detector[3:1]};
        if (state == SHIFT) begin
            shift_counter <= shift_counter + 1;
        end else begin
            shift_counter <= 2'b00;
        end
        case (state)
            IDLE: begin
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            SHIFT: begin
                shift_ena <= 1;
                counting <= 0;
                done <= 0;
            end
            COUNTING: begin
                shift_ena <= 0;
                counting <= 1;
                done <= 0;
            end
            DONE_WAIT: begin
                shift_ena <= 0;
                counting <= 0;
                done <= 1;
            end
        endcase
    end
end

always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (pattern_detector == 4'b1101) begin
                next_state = SHIFT;
            end
        end
        SHIFT: begin
            if (shift_counter == 4) begin
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

endmodule