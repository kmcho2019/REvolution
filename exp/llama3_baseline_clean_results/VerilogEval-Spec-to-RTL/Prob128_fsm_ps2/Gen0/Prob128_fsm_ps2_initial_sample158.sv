module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: STATE_1, 2: STATE_2, 3: not used

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    state <= 1; // STATE_1
                end
            end
            1: begin // STATE_1
                state <= 2; // STATE_2
            end
            2: begin // STATE_2
                state <= 0; // IDLE
                done <= 1;
            end
            default: begin
                state <= 0; // IDLE
            end
        endcase
    end
end

always @(posedge clk) begin
    if (~reset) begin
        if (state != 2) begin
            done <= 0;
        end
    end
end

endmodule