module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [2:0] state; // IDLE, SHIFT, COUNTING, DONE
reg [1:0] shift_count; // counter for shifting in duration
reg [3:0] pattern; // register to store the detected pattern
reg pattern_detected; // flag to indicate if the pattern is detected
reg [3:0] pattern_value; // value of the pattern to detect

assign pattern_value = 4'b1101;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        pattern_detected <= 1'b0;
        pattern <= 4'b0000;
        shift_count <= 2'b00;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            0: begin // IDLE
                pattern <= {data, pattern[3:1]};
                if (pattern == pattern_value) begin
                    pattern_detected <= 1'b1;
                    state <= 1; // SHIFT
                end
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            1: begin // SHIFT
                shift_ena <= 1'b1;
                if (shift_count == 2'b11) begin
                    state <= 2; // COUNTING
                    shift_count <= 2'b00;
                end else begin
                    shift_count <= shift_count + 1'b1;
                end
                counting <= 1'b0;
                done <= 1'b0;
            end
            2: begin // COUNTING
                shift_ena <= 1'b0;
                counting <= 1'b1;
                if (done_counting) begin
                    state <= 3; // DONE
                end
                done <= 1'b0;
            end
            3: begin // DONE
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b1;
                if (ack) begin
                    state <= 0; // IDLE
                    pattern_detected <= 1'b0;
                end
            end
            default: begin
                state <= 0; // IDLE
                pattern_detected <= 1'b0;
                pattern <= 4'b0000;
                shift_count <= 2'b00;
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
        endcase
    end
end

endmodule