module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [2:0] state;  // 0: IDLE, 1: DETECT, 2: SHIFT, 3: COUNT, 4: DONE
reg [3:0] delay;  // Delay value
reg [3:0] remaining_time;  // Remaining time
reg [9:0] clock_count;  // Clock counter
reg counting_reg;  // Counting signal
reg done_reg;  // Done signal
reg [3:0] shift_reg;  // Shift register for input data
reg [3:0] data_shift_reg;  // Shift register for delay value

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
        delay <= 0;
        remaining_time <= 0;
        clock_count <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        shift_reg <= 0;
        data_shift_reg <= 0;
    end else begin
        case (state)
            3'b000: begin  // IDLE
                if (data == 1'b1) begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= 3'b001;
                        shift_reg <= 0;
                    end
                end else begin
                    shift_reg <= {shift_reg[2:0], data};
                end
            end
            3'b001: begin  // DETECT
                data_shift_reg <= {data_shift_reg[2:0], data};
                if (data_shift_reg[3] == 1'b1) begin
                    state <= 3'b010;
                    delay <= data_shift_reg;
                    remaining_time <= delay + 1;
                    clock_count <= 0;
                    data_shift_reg <= 0;
                end
            end
            3'b010: begin  // SHIFT
                state <= 3'b011;
            end
            3'b011: begin  // COUNT
                counting_reg <= 1;
                clock_count <= clock_count + 1;
                if (clock_count == 1000) begin
                    clock_count <= 0;
                    remaining_time <= remaining_time - 1;
                    if (remaining_time == 0) begin
                        state <= 3'b100;
                        counting_reg <= 0;
                    end
                end
            end
            3'b100: begin  // DONE
                done_reg <= 1;
                if (ack) begin
                    state <= 3'b000;
                    done_reg <= 0;
                end
            end
        endcase
    end
end

assign count = (state == 3'b011) ? remaining_time : 4'b0000;
assign counting = counting_reg;
assign done = done_reg;

endmodule