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

enum logic [1:0] {IDLE, DETECT, SHIFT, COUNT, DONE} state, next_state;

always_comb begin
    case (state)
        IDLE: begin
            if (data == 1'b1 && next_state == IDLE) begin
                next_state = IDLE;
            end else if (data == 1'b1 && next_state == DETECT) begin
                next_state = DETECT;
            end else begin
                next_state = IDLE;
            end
        end
        DETECT: begin
            if (data == 1'b0 && next_state == DETECT) begin
                next_state = DETECT;
            end else if (data == 1'b1 && next_state == SHIFT) begin
                next_state = SHIFT;
            end else begin
                next_state = DETECT;
            end
        end
        SHIFT: begin
            if (next_state == SHIFT) begin
                next_state = SHIFT;
            end else if (next_state == COUNT) begin
                next_state = COUNT;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            if (next_state == COUNT && done_counting == 1'b0) begin
                next_state = COUNT;
            end else if (next_state == DONE && done_counting == 1'b1) begin
                next_state = DONE;
            end else begin
                next_state = COUNT;
            end
        end
        DONE: begin
            if (next_state == DONE && ack == 1'b0) begin
                next_state = DONE;
            end else if (next_state == IDLE && ack == 1'b1) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
        default: next_state = IDLE;
    endcase
end

reg [3:0] pattern;
reg [1:0] shift_count;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        shift_count <= 2'b00;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        state <= next_state;
        pattern <= {pattern[2:0], data};
        if (state == DETECT && pattern == 4'b1101) begin
            shift_ena <= 1'b1;
            shift_count <= 2'b00;
        end else if (state == SHIFT) begin
            shift_count <= shift_count + 1'b1;
            if (shift_count == 2'b11) begin
                shift_ena <= 1'b0;
            end
        end else if (state == COUNT) begin
            counting <= 1'b1;
        end else if (state == DONE) begin
            done <= 1'b1;
        end else if (state == IDLE) begin
            counting <= 1'b0;
            done <= 1'b0;
        end
        if (state == DONE && ack == 1'b1) begin
            done <= 1'b0;
        end
    end
end

endmodule