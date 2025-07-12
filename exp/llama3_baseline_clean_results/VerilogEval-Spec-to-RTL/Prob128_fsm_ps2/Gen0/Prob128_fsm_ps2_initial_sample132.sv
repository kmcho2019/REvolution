module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: BYTE3 (not used)
reg prev_in_3; // previous value of in[3]

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3] == 1) begin
                    state <= 1;
                end
            end
            1: begin // BYTE1
                state <= 2;
            end
            2: begin // BYTE2
                state <= 3'd0; // transition to IDLE and assert done in the same cycle
                done <= 1;
            end
            default: begin
                state <= 0;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (~reset) begin
        if (state == 3'd0 && in[3] == 1) begin
            prev_in_3 <= 1;
        end else begin
            prev_in_3 <= 0;
        end
    end
end

// to avoid done being asserted on the next cycle if it's still in the IDLE state
always @(posedge clk) begin
    if (reset || state == 3'd0) begin
        done <= 0;
    end
end

endmodule