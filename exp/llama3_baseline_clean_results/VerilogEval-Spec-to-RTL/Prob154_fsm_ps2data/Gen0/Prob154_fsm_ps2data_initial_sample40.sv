module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [23:0] out_bytes_reg;
reg done_reg;
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done_reg <= 0;
        out_bytes_reg <= 0;
        byte1 <= 0;
        byte2 <= 0;
        byte3 <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (in[3]) begin
                    byte1 <= in;
                    state <= 1;
                end
            end
            1: begin // Byte1
                byte2 <= in;
                state <= 2;
            end
            2: begin // Byte2
                byte3 <= in;
                state <= 3;
            end
            3: begin // Byte3
                done_reg <= 1;
                out_bytes_reg <= {byte1, byte2, byte3};
                state <= 0;
            end
        endcase
        if (~done_reg) begin
            done_reg <= 0;
        end
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule