module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 0: idle, 1: byte1, 2: byte2, 3: byte3
reg [7:0] byte1, byte2, byte3;

always @ (posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (in[3] == 1) begin
                    byte1 <= in;
                    state <= 1;
                end
                done <= 0;
            end
            1: begin // byte1
                byte2 <= in;
                state <= 2;
                done <= 0;
            end
            2: begin // byte2
                byte3 <= in;
                state <= 0; // go back to idle
                done <= 1; // signal done
            end
            default: state <= 0;
        endcase
    end
end

endmodule