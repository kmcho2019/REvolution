module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [3:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE, 4: ACK
reg [3:0] counter; // counter for the 4-bit duration
reg [3:0] pattern_reg; // register to store the pattern

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset to IDLE state
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                pattern_reg <= {pattern_reg[2:0], data};
                if (pattern_reg == 4'b1101) begin
                    state <= 1; // transition to SHIFT state
                    shift_ena <= 1;
                    counter <= 0;
                end else begin
                    state <= 0; // stay in IDLE state
                    shift_ena <= 0;
                end
            end
            1: begin // SHIFT state
                counter <= counter + 1;
                if (counter == 4) begin
                    state <= 2; // transition to COUNT state
                    shift_ena <= 0;
                    counting <= 1;
                end
            end
            2: begin // COUNT state
                if (done_counting) begin
                    state <= 3; // transition to DONE state
                    counting <= 0;
                    done <= 1;
                end
            end
            3: begin // DONE state
                if (ack) begin
                    state <= 4; // transition to ACK state
                    done <= 0;
                end
            end
            4: begin // ACK state
                state <= 0; // transition back to IDLE state
            end
        endcase
    end
end

endmodule