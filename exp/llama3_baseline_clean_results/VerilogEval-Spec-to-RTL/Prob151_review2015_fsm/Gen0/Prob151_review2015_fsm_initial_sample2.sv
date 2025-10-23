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

reg [3:0] state; // 4 states: IDLE, SHIFT, COUNT, DONE
reg [1:0] shift_count; // counter to keep track of the number of bits shifted
reg [3:0] pattern; // register to store the received pattern

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE state
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        pattern <= 0;
        shift_count <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data == 1) begin // receive first bit of pattern
                    pattern <= pattern << 1 | data;
                    if (pattern == 4'b1101) begin // pattern detected
                        state <= 1; // transition to SHIFT state
                        shift_ena <= 1;
                        pattern <= 0;
                    end
                end else if (data == 0) begin
                    pattern <= pattern << 1;
                end
            end
            1: begin // SHIFT state
                if (shift_count == 4) begin // 4 bits shifted
                    state <= 2; // transition to COUNT state
                    counting <= 1;
                    shift_ena <= 0;
                end else begin
                    shift_count <= shift_count + 1;
                end
            end
            2: begin // COUNT state
                if (done_counting) begin // counters finished counting
                    state <= 3; // transition to DONE state
                    counting <= 0;
                    done <= 1;
                end
            end
            3: begin // DONE state
                if (ack) begin // acknowledgement received
                    state <= 0; // transition to IDLE state
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule