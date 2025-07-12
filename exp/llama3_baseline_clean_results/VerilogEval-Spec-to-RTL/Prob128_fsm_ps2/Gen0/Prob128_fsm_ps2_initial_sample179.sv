module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: BYTE_1, 2: BYTE_2, 3: BYTE_3 (not needed, we'll use 2 for BYTE_3)
reg prev_in_3;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    state <= 1;
                end else begin
                    state <= 0;
                end
                done <= 0;
            end
            1: begin // BYTE_1
                state <= 2;
                done <= 0;
            end
            2: begin // BYTE_2
                state <= 2;
                done <= 0;
            end
            default: begin // BYTE_3 (also 2)
                state <= 0;
                if (prev_in_3) begin
                    done <= 1;
                end else begin
                    state <= 2;
                    done <= 0;
                end
            end
        endcase
    end
    prev_in_3 <= in[3];
end

endmodule