module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [1:0] state; // 0: IDLE, 1: PATTERN_MATCH, 2: COUNTING, 3: DONE
reg [3:0] counter; // counter for shift_ena
reg [3:0] pattern; // shift register for pattern detection

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        pattern <= 0;
        counter <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        case (state)
            0: begin // IDLE
                if (pattern == 4'b1101) begin
                    state <= 1;
                    counter <= 0;
                end
                else begin
                    pattern <= {pattern[2:0], data};
                end
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            1: begin // PATTERN_MATCH
                if (counter == 4) begin
                    state <= 2;
                end
                else begin
                    counter <= counter + 1;
                end
                shift_ena <= (counter < 4);
                counting <= 0;
                done <= 0;
            end
            2: begin // COUNTING
                if (done_counting) begin
                    state <= 3;
                end
                shift_ena <= 0;
                counting <= 1;
                done <= 0;
            end
            3: begin // DONE
                if (ack) begin
                    state <= 0;
                    pattern <= 0;
                end
                shift_ena <= 0;
                counting <= 0;
                done <= 1;
            end
            default: begin
                state <= 0;
                pattern <= 0;
                counter <= 0;
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
        endcase
    end
end

endmodule