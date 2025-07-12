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
reg [3:0] remaining;
reg [9:0] clock_counter;
reg [3:0] pattern_detector;
reg counting_reg;
reg done_reg;
reg [1:0] state; // 0: Idle, 1: Shift, 2: Counting, 3: Done

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        pattern_detector <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        clock_counter <= 0;
        remaining <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (data == 1 && pattern_detector == 0) begin
                    pattern_detector <= 1;
                end else if (data == 1 && pattern_detector == 1) begin
                    pattern_detector <= 2;
                end else if (data == 0 && pattern_detector == 2) begin
                    pattern_detector <= 3;
                end else if (data == 1 && pattern_detector == 3) begin
                    pattern_detector <= 4;
                    state <= 1;
                end else begin
                    pattern_detector <= 0;
                end
            end
            1: begin // Shift
                delay <= {data, delay[3:1]};
                if (delay[3:1] == 0) begin
                    state <= 2;
                    clock_counter <= 0;
                    remaining <= delay;
                    counting_reg <= 1;
                end
            end
            2: begin // Counting
                clock_counter <= clock_counter + 1;
                if (clock_counter == 1000 - 1) begin
                    remaining <= remaining - 1;
                    clock_counter <= 0;
                end
                if (remaining == 0) begin
                    state <= 3;
                    counting_reg <= 0;
                    done_reg <= 1;
                end
            end
            3: begin // Done
                if (ack) begin
                    state <= 0;
                    done_reg <= 0;
                    pattern_detector <= 0;
                end
            end
        endcase
    end
end

assign count = (state == 2) ? remaining : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule