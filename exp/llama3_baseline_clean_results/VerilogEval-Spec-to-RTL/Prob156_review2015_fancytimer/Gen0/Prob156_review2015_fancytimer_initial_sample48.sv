module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] state; // 0: IDLE, 1: SHIFT_DELAY, 2: COUNTING, 3: DONE
reg [3:0] delay; // 4-bit delay value
reg [3:0] remaining; // remaining time
reg [9:0] counter; // 10-bit counter for 1000 clock cycles
reg [3:0] shift_counter; // 4-bit counter for shifting in delay
reg [3:0] pattern; // 4-bit register for pattern detection
reg counting_out;
reg done_out;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset to IDLE state
        pattern <= 0;
        shift_counter <= 0;
        counter <= 0;
        remaining <= 0;
        delay <= 0;
        counting_out <= 0;
        done_out <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                pattern <= {data, pattern[3:1]};
                if (pattern == 4'b1101) begin
                    state <= 1; // go to SHIFT_DELAY state
                    shift_counter <= 0;
                end
            end
            1: begin // SHIFT_DELAY
                delay <= {data, delay[3:1]};
                shift_counter <= shift_counter + 1;
                if (shift_counter == 4) begin
                    state <= 2; // go to COUNTING state
                    remaining <= delay;
                    counter <= 0;
                    counting_out <= 1;
                end
            end
            2: begin // COUNTING
                counter <= counter + 1;
                if (counter == 1000) begin
                    remaining <= remaining - 1;
                    counter <= 0;
                    if (remaining == 0) begin
                        state <= 3; // go to DONE state
                        counting_out <= 0;
                        done_out <= 1;
                    end
                end
                count <= remaining;
            end
            3: begin // DONE
                if (ack) begin
                    state <= 0; // go back to IDLE state
                    done_out <= 0;
                end
            end
        endcase
    end
end

assign counting = counting_out;
assign done = done_out;

endmodule