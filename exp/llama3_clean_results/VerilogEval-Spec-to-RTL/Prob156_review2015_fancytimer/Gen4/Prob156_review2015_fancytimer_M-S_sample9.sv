module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [1:0] state; // 0: IDLE, 1: COUNT, 2: DONE
reg [3:0] delay; // delay value
reg [3:0] pattern; // input pattern
reg [9:0] remaining_time; // remaining time
reg [3:0] count_out; // output count
reg counting_reg; // counting output
reg done_reg; // done output

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // reset to IDLE state
        counting_reg <= 0;
        done_reg <= 0;
        pattern <= 0;
        delay <= 0;
        remaining_time <= 0;
        count_out <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                pattern <= {data, pattern[2:0]}; // shift in pattern
                if (pattern == 4'b1101) begin
                    pattern <= 0;
                    delay <= 0; // reset delay
                    state <= 1; // move to COUNT state
                    counting_reg <= 1;
                    for (int i = 0; i < 4; i++) begin
                        @(posedge clk);
                        if (reset) begin
                            state <= 0; // reset to IDLE state
                            counting_reg <= 0;
                            done_reg <= 0;
                            pattern <= 0;
                            delay <= 0;
                            remaining_time <= 0;
                            count_out <= 0;
                            break;
                        end else begin
                            delay <= {data, delay[2:0]}; // shift in delay value
                        end
                    end
                    remaining_time <= (delay + 1) * 1000;
                    count_out <= delay + 1;
                end
            end
            1: begin // COUNT state
                remaining_time <= remaining_time - 1;
                if (remaining_time == 0) begin
                    state <= 2; // move to DONE state
                    counting_reg <= 0;
                end else if (remaining_time % 1000 == 0) begin
                    count_out <= count_out - 1;
                end
            end
            2: begin // DONE state
                done_reg <= 1;
                if (ack) begin // check for acknowledgement
                    state <= 0; // reset to IDLE state
                    done_reg <= 0;
                    count_out <= 0;
                end
            end
            default: state <= 0;
        endcase
    end
end

assign counting = counting_reg;
assign done = done_reg;
assign count = count_out;

endmodule