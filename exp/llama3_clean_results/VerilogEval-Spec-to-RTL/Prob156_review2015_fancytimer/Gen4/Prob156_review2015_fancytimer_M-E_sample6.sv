module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [2:0] state;  // 0: IDLE, 1: START_PATTERN, 2: SHIFT_DELAY, 3: COUNTDOWN, 4: DONE
reg [3:0] delay;  // Delay value
reg [9:0] countdown;  // Countdown counter
reg counting_reg;  // Counting signal
reg done_reg;  // Done signal
reg [3:0] shift_reg;  // Shift register for input data
reg [3:0] pattern_reg;  // Shift register for start pattern

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
        delay <= 0;
        countdown <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        shift_reg <= 0;
        pattern_reg <= 0;
    end else begin
        case (state)
            3'b000: begin  // IDLE state
                if (pattern_reg == 4'b1101) begin
                    state <= 3'b001;
                    pattern_reg <= 0;
                end else begin
                    pattern_reg <= {pattern_reg[2:0], data};
                end
            end
            3'b001: begin  // START_PATTERN state
                shift_reg <= {shift_reg[2:0], data};
                if (shift_reg[3]) begin
                    state <= 3'b010;
                    delay <= shift_reg;
                    countdown <= (delay + 1) * 1000;
                end
            end
            3'b010: begin  // SHIFT_DELAY state (Not needed, so removed)
                state <= 3'b011;
            end
            3'b011: begin  // COUNTDOWN state
                counting_reg <= 1;
                countdown <= countdown - 1;
                if (countdown == 0) begin
                    state <= 3'b100;
                    counting_reg <= 0;
                end
            end
            3'b100: begin  // DONE state
                done_reg <= 1;
                if (ack) begin
                    state <= 3'b000;
                    done_reg <= 0;
                end
            end
        endcase
    end
end

assign count = (state == 3'b011) ? (countdown / 1000) : 4'b0000;
assign counting = counting_reg;
assign done = done_reg;

endmodule