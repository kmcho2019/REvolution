module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state;
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        byte1 <= 0;
        byte2 <= 0;
        byte3 <= 0;
        out_bytes <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    byte1 <= in;
                    state <= 1; // RECEIVING
                end
                done <= 0;
            end
            1: begin // RECEIVING
                byte2 <= in;
                state <= 2; // RECEIVING
                done <= 0;
            end
            2: begin // RECEIVING
                byte3 <= in;
                state <= 3; // DONE
                done <= 1;
            end
            3: begin // DONE
                out_bytes <= {byte1, byte2, byte3};
                state <= 0; // IDLE
            end
            default: begin
                state <= 0; // IDLE
                done <= 0;
            end
        endcase
    end
end

endmodule