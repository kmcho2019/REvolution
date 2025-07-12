module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [3:0] shift_cnt;
reg [3:0] state; // 0 - IDLE, 1 - PATTERN_DETECT, 2 - SHIFT, 3 - COUNT, 4 - DONE
reg [3:0] pattern;
reg [3:0] pattern_cnt;

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        shift_cnt <= 0;
        pattern <= 0;
        pattern_cnt <= 0;
    end else begin
        case(state)
            0: begin // IDLE
                if(pattern == 4'b1101) begin
                    state <= 1;
                    pattern <= 0;
                    pattern_cnt <= 0;
                end else if(data == 1) begin
                    pattern <= {pattern[2:0], 1'b1};
                    pattern_cnt <= pattern_cnt + 1;
                end else if(data == 0) begin
                    pattern <= {pattern[2:0], 1'b0};
                    pattern_cnt <= pattern_cnt + 1;
                end
            end
            1: begin // PATTERN_DETECT
                shift_ena <= 1;
                state <= 2;
            end
            2: begin // SHIFT
                shift_ena <= 1;
                shift_cnt <= shift_cnt + 1;
                if(shift_cnt == 4) begin
                    shift_ena <= 0;
                    counting <= 1;
                    state <= 3;
                    shift_cnt <= 0;
                end
            end
            3: begin // COUNT
                if(done_counting) begin
                    counting <= 0;
                    done <= 1;
                    state <= 4;
                end
            end
            4: begin // DONE
                if(ack) begin
                    done <= 0;
                    state <= 0;
                end
            end
        endcase
    end
end

endmodule