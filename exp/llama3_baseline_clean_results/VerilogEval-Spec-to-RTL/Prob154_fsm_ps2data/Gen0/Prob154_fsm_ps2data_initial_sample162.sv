module TopModule(
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

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
        out_bytes_reg <= 24'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // idle state
                if (in[3] == 1'b1) begin
                    state <= 2'b01;
                    byte1 <= in;
                end
            end
            2'b01: begin // byte1 state
                state <= 2'b10;
                byte2 <= in;
            end
            2'b10: begin // byte2 state
                state <= 2'b11;
                byte3 <= in;
            end
            2'b11: begin // done state
                state <= 2'b00;
                out_bytes_reg <= {byte1, byte2, byte3};
                done_reg <= 1'b1;
            end
        endcase
        if (state != 2'b11) begin
            done_reg <= 1'b0;
        end
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule