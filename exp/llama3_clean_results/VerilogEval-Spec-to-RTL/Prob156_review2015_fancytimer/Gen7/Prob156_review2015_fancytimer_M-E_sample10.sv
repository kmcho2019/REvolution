module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state; // 0: IDLE, 1: SHIFT_PATTERN, 2: SHIFT_DELAY, 3: COUNT, 4: DONE
reg [3:0] pattern; // input pattern
reg [3:0] delay; // delay value
reg [9:0] counter; // counter for clock cycles
reg counting_reg; // counting output
reg done_reg; // done output
reg [3:0] count_reg; // count output

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // reset to IDLE state
        counting_reg <= 0;
        done_reg <= 0;
        pattern <= 0;
        delay <= 0;
        counter <= 0;
        count_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data == 1 && pattern[3:1] == 3'b110) begin
                    pattern <= {data, pattern[2:0]}; // shift in pattern
                    if (pattern[3:0] == 4'b1101) begin
                        state <= 1; // move to SHIFT_PATTERN state
                    end
                end else if (data == 1) begin
                    pattern <= {data, pattern[2:0]}; // shift in pattern
                end else begin
                    pattern <= {1'b0, pattern[2:0]}; // shift in pattern
                end
            end
            1: begin // SHIFT_PATTERN state
                if (data == 1) begin
                    pattern <= {data, pattern[2:0]}; // shift in pattern
                    if (pattern[3:0] == 4'b1101) begin
                        state <= 2; // move to SHIFT_DELAY state
                    end
                end else begin
                    pattern <= {1'b0, pattern[2:0]}; // shift in pattern
                end
            end
            2: begin // SHIFT_DELAY state
                if (data == 1) begin
                    delay <= {data, delay[2:0]}; // shift in delay
                    if (delay[3:0]!= 0) begin
                        state <= 3; // move to COUNT state
                        counter <= (delay + 1) * 1000; // set counter
                        counting_reg <= 1;
                    end
                end else begin
                    delay <= {1'b0, delay[2:0]}; // shift in delay
                end
            end
            3: begin // COUNT state
                if (counter > 0) begin
                    counter <= counter - 1; // decrement counter
                    count_reg <= delay; // set count
                    if (counter <= 1000) begin
                        count_reg <= delay - 1; // decrement count
                    end
                end else begin
                    state <= 4; // move to DONE state
                    counting_reg <= 0;
                end
            end
            4: begin // DONE state
                done_reg <= 1;
                if (ack) begin // check for acknowledgement
                    state <= 0; // reset to IDLE state
                    done_reg <= 0;
                    counting_reg <= 0;
                    pattern <= 0;
                    delay <= 0;
                    counter <= 0;
                    count_reg <= 0;
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