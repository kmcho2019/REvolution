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
reg [3:0] count_reg;
reg [9:0] clock_counter;
reg [3:0] shift_reg;
reg [1:0] pattern_detector;
reg counting_reg;
reg done_reg;
reg [3:0] remaining_time;

always @(posedge clk) begin
    if (reset) begin
        pattern_detector <= 0;
        shift_reg <= 0;
        delay <= 0;
        count_reg <= 0;
        clock_counter <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        remaining_time <= 0;
    end
    else begin
        case (pattern_detector)
            0: begin
                if (data == 1) begin
                    pattern_detector <= 1;
                end
            end
            1: begin
                if (data == 1) begin
                    pattern_detector <= 2;
                end
                else begin
                    pattern_detector <= 0;
                end
            end
            2: begin
                if (data == 0) begin
                    pattern_detector <= 3;
                end
                else begin
                    pattern_detector <= 0;
                end
            end
            3: begin
                if (data == 1) begin
                    // Start shifting in the delay value
                    shift_reg <= {data, shift_reg[2:0]};
                    pattern_detector <= 4;
                end
                else begin
                    pattern_detector <= 0;
                end
            end
            4: begin
                // Finish shifting in the delay value
                shift_reg <= {data, shift_reg[2:0]};
                if (shift_reg == 4'b1111) begin
                    delay <= shift_reg;
                    pattern_detector <= 5;
                end
                else if (shift_reg == 4'b1110) begin
                    delay <= {1'b0, shift_reg[2:0]};
                    pattern_detector <= 5;
                end
                else if (shift_reg == 4'b1101) begin
                    delay <= {2'b00, shift_reg[1:0]};
                    pattern_detector <= 5;
                end
                else if (shift_reg == 4'b1100) begin
                    delay <= {2'b01, shift_reg[0]};
                    pattern_detector <= 5;
                end
                else if (shift_reg == 4'b1011) begin
                    delay <= {3'b001, shift_reg[0]};
                    pattern_detector <= 5;
                end
                else if (shift_reg == 4'b1010) begin
                    delay <= {3'b010};
                    pattern_detector <= 5;
                end
                else if (shift_reg == 4'b1001) begin
                    delay <= {3'b011};
                    pattern_detector <= 5;
                end
                else if (shift_reg == 4'b1000) begin
                    delay <= {3'b100};
                    pattern_detector <= 5;
                end
                else if (shift_reg == 4'b0111) begin
                    delay <= {3'b101};
                    pattern_detector <= 5;
                end
                else if (shift_reg == 4'b0110) begin
                    delay <= {3'b110};
                    pattern_detector <= 5;
                end
                else if (shift_reg == 4'b0101) begin
                    delay <= {3'b111};
                    pattern_detector <= 5;
                end
                else if (shift_reg == 4'b0100) begin
                    delay <= 4'b0000;
                    pattern_detector <= 5;
                end
                else if (shift_reg == 4'b0011) begin
                    delay <= 4'b0001;
                    pattern_detector <= 5;
                end
                else if (shift_reg == 4'b0010) begin
                    delay <= 4'b0010;
                    pattern_detector <= 5;
                end
                else if (shift_reg == 4'b0001) begin
                    delay <= 4'b0011;
                    pattern_detector <= 5;
                end
                else if (shift_reg == 4'b0000) begin
                    delay <= 4'b0100;
                    pattern_detector <= 5;
                end
            end
            5: begin
                // Start counting
                counting_reg <= 1;
                remaining_time <= delay;
                clock_counter <= 0;
                pattern_detector <= 6;
            end
            6: begin
                // Counting
                if (clock_counter == 999) begin
                    if (remaining_time > 0) begin
                        remaining_time <= remaining_time - 1;
                        clock_counter <= 0;
                    end
                    else begin
                        counting_reg <= 0;
                        done_reg <= 1;
                        pattern_detector <= 7;
                    end
                end
                else begin
                    clock_counter <= clock_counter + 1;
                end
            end
            7: begin
                // Done, waiting for ack
                if (ack) begin
                    done_reg <= 0;
                    pattern_detector <= 0;
                end
            end
        endcase
    end
end

assign count = remaining_time;
assign counting = counting_reg;
assign done = done_reg;

endmodule