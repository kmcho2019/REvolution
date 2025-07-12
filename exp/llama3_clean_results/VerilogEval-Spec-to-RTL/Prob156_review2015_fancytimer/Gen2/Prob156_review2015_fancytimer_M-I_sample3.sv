module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] delay; // delay value
reg [3:0] pattern; // input pattern
reg [9:0] cycle_count; // counter for clock cycles
reg [9:0] remaining_time; // remaining time
reg counting_reg; // counting output
reg done_reg; // done output

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // reset to IDLE state
        counting_reg <= 0;
        done_reg <= 0;
        pattern <= 0;
        delay <= 0;
        cycle_count <= 0;
        remaining_time <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                pattern <= {data, pattern[2:0]}; // shift in pattern
                if (pattern == 4'b1101) begin
                    state <= 1; // move to SHIFT state
                end
            end
            1: begin // SHIFT state
                delay <= {data, delay[2:0]}; // shift in delay value
                cycle_count <= cycle_count + 1;
                if (cycle_count == 3) begin // check if all 4 bits have been shifted
                    state <= 2; // move to COUNT state
                    counting_reg <= 1;
                    cycle_count <= 0;
                    remaining_time <= (delay + 1) * 1000;
                end
            end
            2: begin // COUNT state
                cycle_count <= cycle_count + 1;
                if (cycle_count == 1000) begin // check if 1000 cycles have passed
                    remaining_time <= remaining_time - 1000;
                    cycle_count <= 0;
                    if (remaining_time == 0) begin
                        state <= 3; // move to DONE state
                        counting_reg <= 0;
                    end
                end
            end
            3: begin // DONE state
                done_reg <= 1;
                if (ack) begin // check for acknowledgement
                    state <= 0; // reset to IDLE state
                    done_reg <= 0;
                end
            end
            default: state <= 0;
        endcase
    end
end

assign counting = counting_reg;
assign done = done_reg;
assign count = remaining_time[11:8];

endmodule