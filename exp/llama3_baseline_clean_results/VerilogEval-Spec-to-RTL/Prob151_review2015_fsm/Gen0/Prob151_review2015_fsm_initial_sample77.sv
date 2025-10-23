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

reg [2:0] state; // 0: IDLE, 1: PATTERN_MATCH, 2: SHIFT, 3: COUNTING, 4: DONE
reg [3:0] counter; // counter for 4 clock cycles in SHIFT state
reg [3:0] data_shift_reg; // shift register for the pattern
reg pattern_match;

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE state
        counter <= 0;
        data_shift_reg <= 0;
        pattern_match <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case(state)
            0: begin // IDLE state
                if (data_shift_reg == 4'b1101) begin
                    state <= 1; // move to PATTERN_MATCH state
                    pattern_match <= 1;
                end else begin
                    data_shift_reg <= {data_shift_reg[2:0], data};
                end
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            1: begin // PATTERN_MATCH state
                state <= 2; // move to SHIFT state
                counter <= 0;
            end
            2: begin // SHIFT state
                shift_ena <= 1;
                if (counter == 4'd3) begin
                    state <= 3; // move to COUNTING state
                    shift_ena <= 0;
                end
                counter <= counter + 1;
                counting <= 0;
                done <= 0;
            end
            3: begin // COUNTING state
                counting <= 1;
                if (done_counting) begin
                    state <= 4; // move to DONE state
                    counting <= 0;
                end
                shift_ena <= 0;
                done <= 0;
            end
            4: begin // DONE state
                done <= 1;
                if (ack) begin
                    state <= 0; // reset to IDLE state
                    done <= 0;
                end
                shift_ena <= 0;
                counting <= 0;
            end
            default: begin
                state <= 0;
                counter <= 0;
                data_shift_reg <= 0;
                pattern_match <= 0;
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
        endcase
    end
end

endmodule