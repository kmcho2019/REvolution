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

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] shift_counter; // counter for SHIFT state
reg [3:0] pattern; // registers to hold the pattern
reg pattern_match; // flag to indicate pattern match

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        shift_counter <= 0;
        pattern <= 0;
        pattern_match <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (pattern_match) begin
                    state <= 1;
                    pattern_match <= 0;
                end else begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        pattern_match <= 1;
                    end else begin
                        pattern_match <= 0;
                    end
                end
            end
            1: begin // SHIFT
                shift_ena <= 1;
                shift_counter <= shift_counter + 1;
                if (shift_counter == 4) begin
                    state <= 2;
                    shift_counter <= 0;
                    shift_ena <= 0;
                end
            end
            2: begin // COUNT
                counting <= 1;
                if (done_counting) begin
                    state <= 3;
                    counting <= 0;
                end
            end
            3: begin // DONE
                done <= 1;
                if (ack) begin
                    state <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule