module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [1:0] state;  // 0: IDLE, 1: DETECT, 2: COUNT, 3: DONE
reg [3:0] delay;  // Delay value
reg [3:0] remaining_time;  // Remaining time
reg [9:0] clock_count;  // Clock counter
reg [3:0] sequence;  // Current sequence of bits
reg counting_reg;  // Counting signal
reg done_reg;  // Done signal

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        delay <= 0;
        remaining_time <= 0;
        clock_count <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        sequence <= 0;
    end else begin
        case (state)
            2'b00: begin  // IDLE
                sequence <= {sequence[2:0], data};
                if (sequence == 4'b1101) begin
                    state <= 2'b01;
                    sequence <= 0;
                end
            end
            2'b01: begin  // DETECT
                sequence <= {sequence[2:0], data};
                if (sequence[3] == 1'b1) begin
                    state <= 2'b10;
                    delay <= sequence;
                    remaining_time <= delay + 1;
                    clock_count <= 0;
                    sequence <= 0;
                end
            end
            2'b10: begin  // COUNT
                counting_reg <= 1;
                clock_count <= clock_count + 1;
                if (clock_count == 1000) begin
                    clock_count <= 0;
                    remaining_time <= remaining_time - 1;
                    if (remaining_time == 0) begin
                        state <= 2'b11;
                        counting_reg <= 0;
                    end
                end
            end
            2'b11: begin  // DONE
                done_reg <= 1;
                if (ack) begin
                    state <= 2'b00;
                    done_reg <= 0;
                end
            end
        endcase
    end
end

assign count = (state == 2'b10) ? remaining_time : 4'b0000;
assign counting = counting_reg;
assign done = done_reg;

endmodule