module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [23:0] out_bytes_reg;
reg [7:0] byte1;
reg [7:0] byte2;
reg [7:0] byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        out_bytes_reg <= 24'd0;
        byte1 <= 8'd0;
        byte2 <= 8'd0;
        byte3 <= 8'd0;
    end
    else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01;
                end
            end
            2'b01: begin // BYTE1 state
                byte2 <= in;
                state <= 2'b10;
            end
            2'b10: begin // BYTE2 state
                byte3 <= in;
                state <= 2'b00;
                out_bytes_reg <= {byte1, byte2, byte3};
            end
            default: state <= 2'b00;
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = (state == 2'b00) && (out_bytes_reg != 24'd0);

endmodule