module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

// Define the states
enum logic [2:0] {
    IDLE = 3'b000,
    SHIFT = 3'b001,
    COUNTING = 3'b010,
    DONE = 3'b011
} state, next_state;

// Shift counter
reg [1:0] shift_counter;
reg [3:0] pattern_detector;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_detector <= 4'b0000;
        shift_counter <= 4'b0000;
    end else begin
        state <= next_state;
        pattern_detector <= {data, pattern_detector[3:1]};
        if (state == SHIFT) begin
            shift_counter <= shift_counter + 1;
        end else begin
            shift_counter <= 4'b0000;
        end
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
                next_state = DONE;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

always_comb begin
    shift_ena = 0;
    counting = 0;
    done = 0;
    case (state)
        IDLE: begin
        end
        SHIFT: begin
            shift_ena = 1;
        end
        COUNTING: begin
            counting = 1;
        end
        DONE: begin
            done = 1;
        end
        default: begin
        end
    endcase
end

endmodule