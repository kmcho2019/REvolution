module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Pattern detection signals
reg [3:0] pattern_reg = 4'b0;

// FSM states
enum logic [1:0] {
    IDLE,
    SHIFT,
    COUNTING,
    DONE
} state, next_state;

// Shifting counter
reg [1:0] shift_count = 2'b0;

always @(*) begin
    // Default outputs
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;

    case(state)
        IDLE: begin
            if (pattern_reg == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                pattern_reg = {pattern_reg[2:0], data};
                next_state = IDLE;
            end
        end
        SHIFT: begin
            shift_ena = 1'b1;
            shift_count = shift_count + 1;
            if (shift_count == 4) begin
                next_state = COUNTING;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNTING: begin
            counting = 1'b1;
            if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNTING;
            end
        end
        DONE: begin
            done = 1'b1;
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 2'b0;
        pattern_reg <= 4'b0;
    end else begin
        state <= next_state;
    end
end

endmodule