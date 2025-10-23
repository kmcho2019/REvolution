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

enum logic [1:0] {
    IDLE,
    SHIFT,
    COUNTING,
    DONE
} state, next_state;

reg [3:0] pattern;
reg [1:0] shift_count;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 2'b00;
        pattern <= 4'b0000;
    end else begin
        state <= next_state;
        if (state == SHIFT) begin
            shift_count <= shift_count + 1'b1;
        end else if (state == IDLE) begin
            pattern[3:1] <= pattern[2:0];
            pattern[0] <= data;
        end
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (pattern == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_count == 2'b11) begin
                next_state = COUNTING;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNTING: begin
            if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNTING;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
    endcase
end

assign shift_ena = (state == SHIFT);
assign counting = (state == COUNTING);
assign done = (state == DONE);

endmodule