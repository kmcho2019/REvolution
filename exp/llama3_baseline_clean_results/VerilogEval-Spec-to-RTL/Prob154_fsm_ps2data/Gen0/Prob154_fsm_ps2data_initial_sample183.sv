module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [23:0] message;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        message <= 24'd0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // idle
                if (in[3] == 1'b1) begin
                    message[7:0] <= in;
                    state <= 2'b01;
                end
            end
            2'b01: begin // byte1
                message[15:8] <= in;
                state <= 2'b10;
            end
            2'b10: begin // byte2
                message[23:16] <= in;
                state <= 2'b11;
                done_reg <= 1'b1;
            end
            2'b11: begin // done_state
                state <= 2'b00;
                done_reg <= 1'b0;
            end
            default: state <= 2'b00;
        endcase
    end
end

assign out_bytes = message;
assign done = done_reg;

endmodule