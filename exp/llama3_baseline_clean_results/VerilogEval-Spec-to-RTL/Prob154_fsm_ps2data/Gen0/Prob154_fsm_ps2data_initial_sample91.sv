module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state; // IDLE = 2'b00, BYTE1 = 2'b01, BYTE2 = 2'b10, BYTE3 = 2'b11
reg [7:0] byte1, byte2;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01;
                end
            end
            2'b01: begin // BYTE1
                byte2 <= in;
                state <= 2'b10;
            end
            2'b10: begin // BYTE2
                out_bytes <= {byte1, byte2, in};
                done <= 1'b1;
                state <= 2'b00;
            end
            default: begin // BYTE3
                done <= 1'b0;
            end
        endcase
    end
end

endmodule