module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // IDLE (0), BYTE1 (1), BYTE2 (2), BYTE3 (3)
reg [7:0] byte1, byte2, byte3;
reg [23:0] out_bytes_reg;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        out_bytes_reg <= 24'd0;
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
                state <= 0; // Go back to IDLE after receiving 3 bytes
                out_bytes_reg <= {byte1, byte2, byte3};
                done <= 1'b1;
            end
            default: state <= 0;
        endcase
        out_bytes <= out_bytes_reg;
        if (state != 2) begin
            done <= 0;
        end
    end
end

endmodule