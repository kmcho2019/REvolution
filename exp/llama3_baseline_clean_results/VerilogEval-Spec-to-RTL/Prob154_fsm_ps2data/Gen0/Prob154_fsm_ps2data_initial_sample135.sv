module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2
reg [7:0] byte1;
reg [7:0] byte2;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        done <= 0;
        out_bytes <= 24'd0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3] == 1) begin
                    state <= 1;
                    byte1 <= in;
                end
            end
            1: begin // BYTE1
                state <= 2;
                byte2 <= in;
            end
            2: begin // BYTE2
                state <= 0;
                done <= 1;
                out_bytes <= {byte1, byte2, in};
            end
        endcase
        if (state != 2) begin
            done <= 0;
        end
    end
end

endmodule