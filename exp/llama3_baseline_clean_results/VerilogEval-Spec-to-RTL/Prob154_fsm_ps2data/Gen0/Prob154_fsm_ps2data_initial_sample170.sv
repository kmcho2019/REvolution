module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state; // 0: idle, 1: first_byte, 2: second_byte

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (in[3] == 1) begin
                    out_bytes[23:16] <= in;
                    state <= 1;
                end else begin
                    state <= 0;
                end
                done <= 0;
            end
            1: begin // first_byte
                out_bytes[15:8] <= in;
                state <= 2;
                done <= 0;
            end
            2: begin // second_byte
                out_bytes[7:0] <= in;
                done <= 1;
                state <= 0;
            end
            default: begin
                state <= 0;
                done <= 0;
            end
        endcase
    end
end

endmodule