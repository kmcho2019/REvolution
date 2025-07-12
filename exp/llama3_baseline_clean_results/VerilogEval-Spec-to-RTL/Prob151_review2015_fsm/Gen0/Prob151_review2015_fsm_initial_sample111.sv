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

// States
typedef enum logic [2:0] {
    IDLE = 3'b000,
    SHIFT = 3'b001,
    COUNTING = 3'b010,
    DONE = 3'b011
} state_t;

state_t state, next_state;

reg [3:0] pattern;
reg [1:0] shift_count;

always @(*) begin
    case (state)
        IDLE: begin
            if (reset) begin
                next_state = IDLE;
            end else if (pattern == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (reset) begin
                next_state = IDLE;
            end else if (shift_count == 2'd3) begin
                next_state = COUNTING;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNTING: begin
            if (reset) begin
                next_state = IDLE;
            end else if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNTING;
            end
        end
        DONE: begin
            if (reset) begin
                next_state = IDLE;
            end else if (ack) begin
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
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        pattern <= 0;
        shift_count <= 0;
    end else begin
        state <= next_state;
        if (state == IDLE) begin
            pattern <= {data, pattern[3:1]};
        end
        if (state == SHIFT) begin
            shift_ena <= 1;
            shift_count <= shift_count + 1;
        end else if (state == COUNTING) begin
            counting <= 1;
            shift_ena <= 0;
        end else if (state == DONE) begin
            done <= 1;
            counting <= 0;
            shift_ena <= 0;
        end else begin
            counting <= 0;
            done <= 0;
            shift_ena <= 0;
        end
        if (next_state == IDLE || next_state == COUNTING) begin
            shift_count <= 0;
        end
    end
end

endmodule