module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [3:0] state;
reg [3:0] pattern_shift;
reg shift_ena;
reg counting;
reg done;
reg [3:0] counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        pattern_shift <= 4'b0000;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        counter <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (pattern_shift == 4'b1101) begin
                    state <= 1; // PENDING
                    pattern_shift <= 4'b0000;
                    shift_ena <= 1;
                    counter <= 0;
                end else if (data == 1) begin
                    pattern_shift <= {pattern_shift[2:0], 1};
                end else if (data == 0) begin
                    pattern_shift <= {pattern_shift[2:0], 0};
                end
            end
            1: begin // PENDING
                shift_ena <= (counter < 4) ? 1 : 0;
                if (counter == 3) begin
                    state <= 2; // COUNTING
                end
                counter <= counter + 1;
            end
            2: begin // COUNTING
                counting <= 1;
                if (done_counting) begin
                    state <= 3; // NOTIFY
                    counting <= 0;
                end
            end
            3: begin // NOTIFY
                done <= 1;
                if (ack) begin
                    state <= 0; // IDLE
                    done <= 0;
                end
            end
            default: begin
                state <= 0; // IDLE
            end
        endcase
    end
end

endmodule