module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [2:0] state; // 0: IDLE, 1: PATTERN_DETECTED, 2: SHIFTING, 3: COUNTING, 4: DONE
reg [3:0] pattern; // to store the detected pattern
reg [1:0] shift_counter; // counter to count the number of bits shifted

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        pattern <= 0;
        shift_counter <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data == 1'b1) begin
                    pattern[0] <= 1'b1;
                    state <= 1;
                end
            end
            1: begin // PATTERN_DETECTED
                if (data == 1'b1) begin
                    pattern[1] <= 1'b1;
                    state <= 2;
                end else begin
                    pattern[0] <= 0;
                    state <= 0;
                end
            end
            2: begin // SHIFTING
                shift_ena <= 1'b1;
                if (shift_counter == 4'd3) begin
                    state <= 3;
                    shift_ena <= 1'b0;
                end else begin
                    shift_counter <= shift_counter + 1'b1;
                end
            end
            3: begin // COUNTING
                counting <= 1'b1;
                if (done_counting) begin
                    state <= 4;
                    counting <= 1'b0;
                end
            end
            4: begin // DONE
                done <= 1'b1;
                if (ack) begin
                    state <= 0;
                    done <= 1'b0;
                end
            end
            default: state <= 0;
        endcase
    end
end

endmodule