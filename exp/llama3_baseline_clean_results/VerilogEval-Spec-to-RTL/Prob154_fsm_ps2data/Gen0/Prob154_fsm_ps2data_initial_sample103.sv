module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2
reg [7:0] byte1, byte2;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        out_bytes <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    byte1 <= in;
                    state <= 1;
                end
            end
            1: begin // BYTE1
                byte2 <= in;
                state <= 2;
            end
            2: begin // BYTE2
                out_bytes <= {byte1, byte2, in};
                done <= 1;
                state <= 0;
            end
            default: state <= 0;
        endcase
        if (done) begin
            done <= 0;
        end
    end
end

endmodule