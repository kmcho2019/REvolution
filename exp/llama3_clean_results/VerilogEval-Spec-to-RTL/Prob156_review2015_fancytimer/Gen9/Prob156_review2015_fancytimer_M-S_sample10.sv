module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [2:0] state; // 0: IDLE, 1: DETECT_PATTERN, 2: SHIFT_DELAY, 3: COUNT, 4: DONE
reg [3:0] pattern; // input pattern
reg [3:0] delay; // delay value
reg [9:0] counter; // counter for clock cycles
reg [3:0] count_reg; // count output
reg counting_reg; // counting output
reg done_reg; // done output
reg [3:0] shift_delay; // shift delay counter

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // reset to IDLE state
        counting_reg <= 0;
        done_reg <= 0;
        pattern <= 0;
        delay <= 0;
        counter <= 0;
        count_reg <= 0;
        shift_delay <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                pattern <= {data, pattern[2:0]}; // shift in pattern
                if (pattern[3:0] == 4'b1101) begin
                    state <= 1; // move to DETECT_PATTERN state
                end
            end
            1: begin // DETECT_PATTERN state
                if (shift_delay < 4) begin
                    delay <= {data, delay[2:0]}; // shift in delay
                    shift_delay <= shift_delay + 1;
                end else begin
                    state <= 2; // move to COUNT state
                    counter <= (delay + 1) * 1000; // set counter
                    counting_reg <= 1;
                    shift_delay <= 0;
                end
            end
            2: begin // COUNT state
                if (counter > 0) begin
                    counter <= counter - 1; // decrement counter
                    if (counter <= (count_reg + 1) * 1000) begin
                        count_reg <= count_reg - 1; // decrement count
                    end
                end else begin
                    state <= 3; // move to DONE state
                    counting_reg <= 0;
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
                    counter <= 0;
                    count_reg <= 4; // reset count to max value
                end
            end
            default: state <= 0;
        endcase
    end
end

assign counting = counting_reg;
assign done = done_reg;
assign count = count_reg;

endmodule