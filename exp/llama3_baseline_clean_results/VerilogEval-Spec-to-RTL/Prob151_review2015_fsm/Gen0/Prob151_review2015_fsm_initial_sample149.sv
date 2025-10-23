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

reg [1:0] state; // IDLE, STARTED, SHIFTING, COUNTING, DONE
reg [3:0] shift_cnt; // Counter for shifting duration bits
reg [3:0] pattern; // Register to store the pattern 1101

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE state
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        shift_cnt <= 0;
        pattern <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data == 1) begin
                    pattern <= {pattern[2:0], 1}; // Shift in data bit
                    if (pattern == 4'b1101) begin
                        state <= 1; // Transition to STARTED state
                        shift_ena <= 1;
                    end
                end else begin
                    pattern <= {pattern[2:0], 0}; // Shift in data bit
                end
            end
            1: begin // STARTED state
                state <= 2; // Transition to SHIFTING state
            end
            2: begin // SHIFTING state
                shift_cnt <= shift_cnt + 1;
                if (shift_cnt == 4) begin
                    state <= 3; // Transition to COUNTING state
                    shift_ena <= 0;
                end
            end
            3: begin // COUNTING state
                counting <= 1;
                if (done_counting) begin
                    state <= 4; // Transition to DONE state
                    counting <= 0;
                    done <= 1;
                end
            end
            4: begin // DONE state
                if (ack) begin
                    state <= 0; // Transition to IDLE state
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule