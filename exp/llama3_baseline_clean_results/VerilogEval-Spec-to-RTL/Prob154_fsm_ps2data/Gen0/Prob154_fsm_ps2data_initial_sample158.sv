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

initial begin
    state = 2'b00;
    byte1 = 8'b0;
    byte2 = 8'b0;
    byte3 = 8'b0;
    out_bytes_reg = 24'b0;
    done_reg = 1'b0;
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
        out_bytes_reg <= 24'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b01: begin // BYTE_1
                byte2 <= in;
                state <= 2'b10;
            end
            2'b10: begin // BYTE_2
                byte3 <= in;
                state <= 2'b11;
            end
            2'b11: begin // BYTE_3
                out_bytes_reg <= {byte1, byte2, byte3};
                done_reg <= 1'b1;
                state <= 2'b00;
            end
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg && (state == 2'b11);

endmodule