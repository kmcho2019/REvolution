module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: BYTE_1, 2: BYTE_2, 3: BYTE_3

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        out_bytes <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin // If in[3] is 1, transition to BYTE_1
                    state <= 1;
                    out_bytes[23:16] <= in;
                end
            end
            1: begin // BYTE_1
                state <= 2;
                out_bytes[15:8] <= in;
            end
            2: begin // BYTE_2
                state <= 3;
                out_bytes[7:0] <= in;
            end
            3: begin // BYTE_3
                state <= 0; // Transition back to IDLE
                done <= 1; // Assert done signal
            end
            default: state <= 0;
        endcase
        if (state == 0 && !in[3]) begin // In IDLE state and in[3] is 0
            done <= 0; // Deassert done signal
        end
        if (state != 3) begin // Not in BYTE_3 state
            done <= 0; // Deassert done signal
        end
    end
end

endmodule