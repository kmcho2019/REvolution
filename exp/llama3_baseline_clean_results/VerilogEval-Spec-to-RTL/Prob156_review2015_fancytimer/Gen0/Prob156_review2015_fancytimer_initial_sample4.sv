module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

reg [3:0] delay;
reg [3:0] remaining;
reg [9:0] counter;
reg [3:0] pattern;
reg [3:0] shift_counter;

enum logic [2:0] {IDLE, SHIFT_DELAY, COUNTING, DONE} state;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 0;
        shift_counter <= 0;
        delay <= 0;
        remaining <= 0;
        counter <= 0;
        counting <= 0;
        done <= 0;
        count <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    pattern <= {pattern[2:0], 1'b1};
                end else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
                if (pattern == 4'b1101) begin
                    pattern <= 0;
                    state <= SHIFT_DELAY;
                end
            end
            SHIFT_DELAY: begin
                if (shift_counter == 4'b0000) begin
                    delay[3] <= data;
                end else if (shift_counter == 4'b0001) begin
                    delay[2] <= data;
                end else if (shift_counter == 4'b0010) begin
                    delay[1] <= data;
                end else if (shift_counter == 4'b0011) begin
                    delay[0] <= data;
                end
                shift_counter <= shift_counter + 1'b1;
                if (shift_counter == 4'b1000) begin
                    remaining <= delay + 1'b1;
                    state <= COUNTING;
                end
            end
            COUNTING: begin
                if (counter == 10'd999) begin
                    counter <= 0;
                    if (remaining > 1'b1) begin
                        remaining <= remaining - 1'b1;
                    end else begin
                        state <= DONE;
                    end
                end else begin
                    counter <= counter + 1'b1;
                end
                counting <= 1'b1;
                count <= remaining - 1'b1;
            end
            DONE: begin
                done <= 1'b1;
                if (ack == 1'b1) begin
                    state <= IDLE;
                    done <= 0;
                    counting <= 0;
                end
            end
        endcase
    end
end

endmodule