module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [7:0] byte1, byte2, byte3;
reg [23:0] out_bytes_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done_reg <= 0;
        out_bytes_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3] == 1) begin
                    byte1 <= in;
                    state <= 1;
                end
            end
            1: begin // BYTE_1
                byte2 <= in;
                state <= 2;
            end
            2: begin // BYTE_2
                byte3 <= in;
                done_reg <= 1;
                state <= 0;
            end
            default: state <= 0;
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        out_bytes_reg <= 0;
    end else if (done_reg) begin
        out_bytes_reg <= {byte1, byte2, byte3};
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule