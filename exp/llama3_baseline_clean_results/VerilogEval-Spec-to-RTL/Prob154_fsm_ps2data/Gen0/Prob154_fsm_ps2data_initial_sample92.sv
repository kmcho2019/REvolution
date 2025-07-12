module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: BYTE3
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        out_bytes <= 24'd0;
        done <= 0;
    end else begin
        case(state)
            0: begin // IDLE
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 1;
                end
            end
            1: begin // BYTE1
                byte2 <= in;
                state <= 2;
            end
            2: begin // BYTE2
                byte3 <= in;
                state <= 3;
            end
            3: begin // BYTE3
                out_bytes <= {byte1, byte2, byte3};
                done <= 1'b1;
                state <= 0;
            end
            default:
                state <= 0;
        endcase
        if (state != 3) begin
            done <= 1'b0;
        end
    end
end

endmodule