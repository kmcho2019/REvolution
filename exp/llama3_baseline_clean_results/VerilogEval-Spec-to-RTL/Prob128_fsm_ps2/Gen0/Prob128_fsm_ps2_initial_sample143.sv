module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: BYTE3
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (in[3]) begin
                    state <= 1; // Transition to BYTE1 state
                    byte1 <= in;
                end
            end
            1: begin // BYTE1 state
                state <= 2; // Transition to BYTE2 state
                byte2 <= in;
            end
            2: begin // BYTE2 state
                state <= 3; // Transition to BYTE3 state
                byte3 <= in;
            end
            3: begin // BYTE3 state
                state <= 0; // Transition back to IDLE state
                done <= 1; // Signal done
            end
            default:
                state <= 0;
        endcase
    end
end

always @(posedge clk) begin
    if (state == 3) begin
        done <= 1;
    end else begin
        done <= 0;
    end
end

endmodule