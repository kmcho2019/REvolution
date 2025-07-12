module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [2:0] state;  // 0: Waiting, 1: Shifting, 2: Counting, 3: Done
reg [3:0] delay;  // Delay value
reg [3:0] remaining_time;  // Remaining time
reg [9:0] clock_count;  // Clock counter
reg [3:0] shift_reg;  // Shift register for input data
reg counting_reg;  // Counting signal
reg done_reg;  // Done signal

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        remaining_time <= 0;
        clock_count <= 0;
        shift_reg <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin  // Waiting for start pattern
                if (shift_reg == 4'b1101) begin
                    state <= 1;
                    shift_reg <= 0;
                end else begin
                    shift_reg <= {shift_reg[2:0], data};
                end
            end
            1: begin  // Shifting in delay value
                shift_reg <= {shift_reg[2:0], data};
                if (shift_reg == 4'b1111) begin
                    delay <= {shift_reg[3:0]};
                    state <= 2;
                    remaining_time <= delay;
                    clock_count <= 0;
                    counting_reg <= 1;
                end
            end
            2: begin  // Counting down delay
                if (clock_count == 999) begin
                    clock_count <= 0;
                    if (remaining_time > 0) begin
                        remaining_time <= remaining_time - 1;
                    end else begin
                        state <= 3;
                        counting_reg <= 0;
                    end
                end else begin
                    clock_count <= clock_count + 1;
                end
            end
            3: begin  // Waiting for acknowledgment
                done_reg <= 1;
                if (ack) begin
                    state <= 0;
                    done_reg <= 0;
                end
            end
        endcase
    end
end

assign count = (state == 2) ? remaining_time : 4'b0000;
assign counting = counting_reg;
assign done = done_reg;

endmodule