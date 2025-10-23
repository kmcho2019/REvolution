module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // IDLE, BYTE1, BYTE2, BYTE3
reg [7:0] byte1, byte2, byte3;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3] == 1) begin
                    byte1 <= in;
                    state <= 1; // BYTE1
                end
            end
            1: begin // BYTE1
                byte2 <= in;
                state <= 2; // BYTE2
            end
            2: begin // BYTE2
                byte3 <= in;
                state <= 3; // BYTE3
            end
            3: begin // BYTE3
                done_reg <= 1;
                state <= 0; // IDLE
            end
            default: state <= 0; // IDLE
        endcase
        if (state == 0 && in[3] == 0) begin
            done_reg <= 0;
        end
    end
end

always @(posedge clk) begin
    if (done_reg) begin
        out_bytes <= {byte1, byte2, byte3};
    end
end

assign done = done_reg;

endmodule