module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] count_reg;
reg counting_reg;
reg done_reg;
reg [3:0] delay_reg;
reg [3:0] remaining_time_reg;
reg [3:0] counter_reg;
reg [3:0] shift_reg;
reg start_pattern_detected;

always @(posedge clk) begin
    if (reset) begin
        count_reg <= 4'b0;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
        delay_reg <= 4'b0;
        remaining_time_reg <= 4'b0;
        counter_reg <= 4'b0;
        shift_reg <= 4'b0;
        start_pattern_detected <= 1'b0;
    end else begin
        case ({start_pattern_detected, counting_reg, done_reg})
            3'b001: begin // start pattern detected, not counting, not done
                if (data == 1'b1) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
                if (shift_reg == 4'b1101) begin
                    start_pattern_detected <= 1'b0;
                    delay_reg <= 4'b0;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b1110) begin
                    start_pattern_detected <= 1'b0;
                    delay_reg <= 4'b1;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b1100) begin
                    start_pattern_detected <= 1'b0;
                    delay_reg <= 4'b2;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b1011) begin
                    start_pattern_detected <= 1'b0;
                    delay_reg <= 4'b3;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b1001) begin
                    start_pattern_detected <= 1'b0;
                    delay_reg <= 4'b4;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b1000) begin
                    start_pattern_detected <= 1'b0;
                    delay_reg <= 4'b5;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b0111) begin
                    start_pattern_detected <= 1'b0;
                    delay_reg <= 4'b6;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b0110) begin
                    start_pattern_detected <= 1'b0;
                    delay_reg <= 4'b7;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b0101) begin
                    start_pattern_detected <= 1'b0;
                    delay_reg <= 4'b8;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b0100) begin
                    start_pattern_detected <= 1'b0;
                    delay_reg <= 4'b9;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b0011) begin
                    start_pattern_detected <= 1'b0;
                    delay_reg <= 4'ha;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b0010) begin
                    start_pattern_detected <= 1'b0;
                    delay_reg <= 4'hb;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b0001) begin
                    start_pattern_detected <= 1'b0;
                    delay_reg <= 4'hc;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b0000) begin
                    start_pattern_detected <= 1'b0;
                    delay_reg <= 4'hd;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else begin
                    start_pattern_detected <= 1'b0;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end
            end
            3'b010: begin // not start pattern detected, counting, not done
                if (counter_reg == 4'b1000) begin
                    counter_reg <= 4'b0;
                    remaining_time_reg <= remaining_time_reg - 1'b1;
                end else begin
                    counter_reg <= counter_reg + 1'b1;
                end
                if (remaining_time_reg == 4'b0) begin
                    counting_reg <= 1'b0;
                    done_reg <= 1'b1;
                end
            end
            3'b011: begin // not start pattern detected, counting, done
                counting_reg <= 1'b0;
                done_reg <= 1'b1;
            end
            3'b100: begin // start pattern detected, not counting, not done
                start_pattern_detected <= 1'b1;
                counting_reg <= 1'b0;
                done_reg <= 1'b0;
            end
            3'b101: begin // start pattern detected, not counting, done
                start_pattern_detected <= 1'b1;
                counting_reg <= 1'b0;
                done_reg <= 1'b0;
            end
            3'b110: begin // start pattern detected, counting, not done
                start_pattern_detected <= 1'b1;
                counting_reg <= 1'b1;
                done_reg <= 1'b0;
            end
            3'b111: begin // start pattern detected, counting, done
                start_pattern_detected <= 1'b1;
                counting_reg <= 1'b1;
                done_reg <= 1'b0;
            end
            default: begin
                if (data == 1'b1) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
                if (shift_reg == 4'b1101) begin
                    start_pattern_detected <= 1'b1;
                    delay_reg <= 4'b0;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b1110) begin
                    start_pattern_detected <= 1'b1;
                    delay_reg <= 4'b1;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b1100) begin
                    start_pattern_detected <= 1'b1;
                    delay_reg <= 4'b2;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b1011) begin
                    start_pattern_detected <= 1'b1;
                    delay_reg <= 4'b3;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b1001) begin
                    start_pattern_detected <= 1'b1;
                    delay_reg <= 4'b4;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b1000) begin
                    start_pattern_detected <= 1'b1;
                    delay_reg <= 4'b5;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b0111) begin
                    start_pattern_detected <= 1'b1;
                    delay_reg <= 4'b6;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b0110) begin
                    start_pattern_detected <= 1'b1;
                    delay_reg <= 4'b7;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b0101) begin
                    start_pattern_detected <= 1'b1;
                    delay_reg <= 4'b8;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b0100) begin
                    start_pattern_detected <= 1'b1;
                    delay_reg <= 4'b9;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b0011) begin
                    start_pattern_detected <= 1'b1;
                    delay_reg <= 4'ha;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b0010) begin
                    start_pattern_detected <= 1'b1;
                    delay_reg <= 4'hb;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b0001) begin
                    start_pattern_detected <= 1'b1;
                    delay_reg <= 4'hc;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end else if (shift_reg == 4'b0000) begin
                    start_pattern_detected <= 1'b1;
                    delay_reg <= 4'hd;
                    counting_reg <= 1'b0;
                    done_reg <= 1'b0;
                end
            end
        endcase
        if (start_pattern_detected == 1'b1 && delay_reg!= 4'b0) begin
            counting_reg <= 1'b1;
            remaining_time_reg <= delay_reg;
        end
        if (done_reg == 1'b1 && ack == 1'b1) begin
            done_reg <= 1'b0;
            counting_reg <= 1'b0;
            start_pattern_detected <= 1'b0;
            delay_reg <= 4'b0;
            remaining_time_reg <= 4'b0;
            counter_reg <= 4'b0;
        end
    end
end

assign count = remaining_time_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule