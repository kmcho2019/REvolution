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

reg [1:0] state;
reg [3:0] shift_count;
reg [3:0] pattern;
reg pattern_detected;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        shift_count <= 0;
        pattern_detected <= 0;
        pattern <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (pattern_detected) begin
                    state <= 1;
                    shift_count <= 0;
                end else begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        pattern_detected <= 1;
                    end else begin
                        pattern_detected <= 0;
                    end
                end
            end
            1: begin // Pattern_Detected
                shift_ena <= 1;
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    state <= 2;
                    shift_ena <= 0;
                end
            end
            2: begin // Shift_Data
                counting <= 1;
                if (done_counting) begin
                    state <= 3;
                    counting <= 0;
                end
            end
            3: begin // Wait_For_Counting
                done <= 1;
                if (ack) begin
                    state <= 0;
                    done <= 0;
                    pattern_detected <= 0;
                    pattern <= 0;
                end
            end
        endcase
    end
end

assign shift_ena = (state == 1);
assign counting = (state == 2);
assign done = (state == 3);

endmodule