module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // IDLE (0), BYTE1 (1), BYTE2 (2), BYTE3 (3)
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    state <= 1; // BYTE1
                end
            end
            1: begin // BYTE1
                state <= 2; // BYTE2
            end
            2: begin // BYTE2
                state <= 3; // BYTE3
            end
            3: begin // BYTE3
                done_reg <= 1;
                state <= 0; // IDLE
            end
            default: state <= 0; // IDLE
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        done <= 0;
    end else begin
        done <= done_reg;
        done_reg <= 0;
    end
end

endmodule