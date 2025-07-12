module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay;
reg [3:0] shift_reg;
reg [9:0] counter;
reg [3:0] remaining_time;
reg pattern_detected;
reg start_count;

enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE
} state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        count <= 4'b0;
        counting <= 1'b0;
        done <= 1'b0;
        delay <= 4'b0;
        shift_reg <= 4'b0;
        counter <= 10'b0;
        remaining_time <= 4'b0;
        pattern_detected <= 1'b0;
        start_count <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1 && shift_reg == 4'b0000) begin
                    shift_reg <= {1'b1, shift_reg[2:0]};
                end else if (data == 1'b0 && shift_reg == 4'b1100) begin
                    pattern_detected <= 1'b1;
                    shift_reg <= 4'b0;
                end else if (data == 1'b0 && shift_reg == 4'b0000) begin
                    shift_reg <= {1'b0, shift_reg[2:0]};
                end else if (data == 1'b1 && shift_reg == 4'b1100) begin
                    shift_reg <= {1'b1, shift_reg[2:0]};
                end
                if (pattern_detected) begin
                    state <= SHIFT;
                end
            end
            SHIFT: begin
                if (shift_reg == 4'b0000) begin
                    shift_reg <= {data, shift_reg[2:0]};
                end else begin
                    shift_reg <= {data, shift_reg[2:0]};
                    if (shift_reg == 4'b1000) begin
                        delay <= {shift_reg[3], shift_reg[2], shift_reg[1], shift_reg[0]};
                        state <= COUNT;
                        start_count <= 1'b1;
                        remaining_time <= delay;
                    end
                end
            end
            COUNT: begin
                if (start_count) begin
                    counter <= 10'b0;
                    start_count <= 1'b0;
                    counting <= 1'b1;
                end
                if (counter == 10'b1111101000) begin
                    remaining_time <= remaining_time - 1'b1;
                    counter <= 10'b0;
                    if (remaining_time == 4'b0) begin
                        state <= DONE;
                    end
                end else begin
                    counter <= counter + 1'b1;
                end
                count <= remaining_time;
            end
            DONE: begin
                done <= 1'b1;
                counting <= 1'b0;
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule