module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg done_reg;
reg [1:0] state_reg;
reg [7:0] byte1_reg;
reg [7:0] byte2_reg;
reg [7:0] byte3_reg;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 2'b00;
        out_bytes_reg <= 24'd0;
        done_reg <= 1'b0;
        byte1_reg <= 8'd0;
        byte2_reg <= 8'd0;
        byte3_reg <= 8'd0;
    end else begin
        case (state_reg)
            2'b00: begin // Idle state
                if (in[3] == 1'b1) begin
                    byte1_reg <= in;
                    state_reg <= 2'b01;
                end
            end
            2'b01: begin // Byte1 state
                byte2_reg <= in;
                state_reg <= 2'b10;
            end
            2'b10: begin // Byte2 state
                byte3_reg <= in;
                state_reg <= 2'b11;
            end
            2'b11: begin // Byte3 state
                out_bytes_reg <= {byte1_reg, byte2_reg, byte3_reg};
                done_reg <= 1'b1;
                state_reg <= 2'b00;
            end
            default: state_reg <= 2'b00;
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg && (state_reg == 2'b11);

endmodule