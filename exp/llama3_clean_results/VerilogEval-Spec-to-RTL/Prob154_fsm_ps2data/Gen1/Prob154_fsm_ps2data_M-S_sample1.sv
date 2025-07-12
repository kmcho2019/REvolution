module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        byte1 <= 8'd0;
        byte2 <= 8'd0;
        byte3 <= 8'd0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
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
                state <= 0;
            end
            default: state <= 0;
        endcase
    end
end

assign out_bytes = (state == 2) ? {byte1, byte2, byte3} : 24'd0;
assign done = (state == 0 && byte3 != 8'd0);

endmodule