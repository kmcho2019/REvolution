module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] delay; // delay value
reg [3:0] pattern; // input pattern
reg [9:0] cycle_count; // counter for clock cycles
reg [3:0] current_delay; // current delay value
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
        current_delay <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (pattern == 4'b1101) begin
                    state <= 1; // move to SHIFT state
                    pattern <= 0;
                end else if (pattern[3:0] == 4'b1101) begin
                    pattern <= {data, pattern[2:0]}; // shift in pattern
                end else begin
                    pattern <= {data, pattern[2:0]}; // continue shifting
                end
            end
            1: begin // SHIFT state
                delay <= {data, delay[2:0]}; // shift in delay value
                cycle_count <= cycle_count + 1;
                if (cycle_count == 3) begin // check if all 4 bits have been shifted
                    state <= 2; // move to COUNT state
                    counting_reg <= 1;
                    cycle_count <= 0;
                    current_delay <= delay;
                end
            end
            2: begin // COUNT state
                cycle_count <= cycle_count + 1;
                if (cycle_count == 1000) begin // check if 1000 cycles have passed
                    cycle_count <= 0;
                    current_delay <= current_delay - 1;
                    if (current_delay == 0) begin
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
                    counting_reg <= 0;
                    pattern <= 0;
                    delay <= 0;
                    cycle_count <= 0;
                    current_delay <= 0;
                end
            end
            default: state <= 0;
        endcase
    end
end

assign counting = counting_reg;
assign done = done_reg;
assign count = current_delay;

endmodule