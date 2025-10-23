module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] state; // 0: IDLE, 1: PATTERN_DETECTED, 2: COUNTING, 3: DONE
reg [3:0] delay; // store the delay value
reg [3:0] current_count; // store the current count value
reg [9:0] counter; // counter to keep track of the remaining clock cycles
reg [3:0] pattern_shift; // shift register to detect the input pattern
reg counting_reg; // register to store the counting output
reg done_reg; // register to store the done output

// define the states
parameter IDLE = 0, PATTERN_DETECTED = 1, COUNTING = 2, DONE = 3;

always @ (posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_shift <= 0;
        delay <= 0;
        current_count <= 0;
        counter <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                // detect the input pattern 1101
                if (data) begin
                    pattern_shift <= {pattern_shift[2:0], 1};
                end else begin
                    pattern_shift <= {pattern_shift[2:0], 0};
                end
                if (pattern_shift == 4'b1101) begin
                    state <= PATTERN_DETECTED;
                    pattern_shift <= 0;
                end
            end
            PATTERN_DETECTED: begin
                // shift in the next 4 bits to determine the delay duration
                if (data) begin
                    delay <= {delay[2:0], 1};
                end else begin
                    delay <= {delay[2:0], 0};
                end
                pattern_shift <= pattern_shift + 1;
                if (pattern_shift == 4) begin
                    state <= COUNTING;
                    counter <= (delay + 1) * 1000 - 1;
                    current_count <= delay;
                end
            end
            COUNTING: begin
                // count down for (delay + 1) * 1000 clock cycles
                counter <= counter - 1;
                if (counter == 0) begin
                    if (current_count > 0) begin
                        current_count <= current_count - 1;
                        counter <= 999;
                    end else begin
                        state <= DONE;
                    end
                end
                counting_reg <= 1;
            end
            DONE: begin
                // assert done and wait for the ack signal to reset
                done_reg <= 1;
                if (ack) begin
                    state <= IDLE;
                    done_reg <= 0;
                    counting_reg <= 0;
                end
            end
        endcase
    end
end

assign count = current_count;
assign counting = counting_reg;
assign done = done_reg;

endmodule