module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2
reg [23:0] msg;
reg [7:0] byte1, byte2;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        msg <= 24'd0;
        byte1 <= 8'd0;
        byte2 <= 8'd0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3] == 1) begin
                    state <= 1; // BYTE1
                    byte1 <= in;
                end
            end
            1: begin // BYTE1
                state <= 2; // BYTE2
                byte2 <= in;
            end
            2: begin // BYTE2
                msg <= {in, byte2, byte1};
                state <= 0; // IDLE
            end
        endcase
    end
end

assign out_bytes = msg;
assign done = (state == 2);

endmodule