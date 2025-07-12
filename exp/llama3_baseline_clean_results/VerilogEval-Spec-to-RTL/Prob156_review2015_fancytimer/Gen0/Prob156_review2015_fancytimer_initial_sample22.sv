module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] delay;
reg [3:0] remaining_time;
reg [9:0] counter;
reg [3:0] pattern;

enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNTING,
    DONE
} state, next_state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 0;
        delay <= 0;
        remaining_time <= 0;
        counter <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    pattern[0] <= 1'b1;
                end else begin
                    pattern[0] <= 1'b0;
                end
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    pattern <= 0;
                end
            end
            SHIFT: begin
                delay <= {data, delay[2:0]};
                if (delay[0] != 0) begin
                    delay <= {1'b0, delay[3:1]};
                end else begin
                    state <= COUNTING;
                    remaining_time <= delay + 1;
                    counter <= 1000;
                end
            end
            COUNTING: begin
                if (counter == 0) begin
                    if (remaining_time == 0) begin
                        state <= DONE;
                    end else begin
                        remaining_time <= remaining_time - 1;
                        counter <= 1000;
                    end
                end else begin
                    counter <= counter - 1;
                end
                count <= remaining_time;
                counting <= 1;
            end
            DONE: begin
                if (ack == 1'b1) begin
                    state <= IDLE;
                end
                done <= 1;
            end
        endcase
    end
end

endmodule