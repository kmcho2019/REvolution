module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay;  // delay duration
reg [3:0] remaining;  // remaining time
reg [9:0] cycle_count;  // cycle count
reg [3:0] shift_reg;  // shift register for pattern detection
reg [3:0] state;  // state register ( Idle: 0, Shift: 1, Counting: 2, Done: 3)

always @(posedge clk) begin
    if (reset) begin  // synchronous reset
        state <= 0;  // reset to Idle state
        shift_reg <= 0;
        delay <= 0;
        remaining <= 0;
        cycle_count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin  // Idle state
                if (data) begin
                    shift_reg <= {shift_reg[2:0], 1};
                end else begin
                    shift_reg <= {shift_reg[2:0], 0};
                end
                if (shift_reg == 4'b1101) begin  // detect 1101 pattern
                    state <= 1;
                end
            end
            1: begin  // Shift state
                if (data) begin
                    delay <= {delay[2:0], 1};
                end else begin
                    delay <= {delay[2:0], 0};
                end
                if (shift_reg == 4'b0000) begin  // finish shifting
                    state <= 2;
                    remaining <= delay + 1;
                    cycle_count <= 0;
                    counting <= 1;
                end else begin
                    shift_reg <= shift_reg - 1;
                end
            end
            2: begin  // Counting state
                cycle_count <= cycle_count + 1;
                if (cycle_count == 1000) begin
                    remaining <= remaining - 1;
                    cycle_count <= 0;
                end
                if (remaining == 0) begin  // finish counting
                    state <= 3;
                    counting <= 0;
                    done <= 1;
                end
                count <= remaining;
            end
            3: begin  // Done state
                if (ack) begin  // wait for ack
                    state <= 0;  // reset to Idle state
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule