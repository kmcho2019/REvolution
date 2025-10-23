module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg done_reg;
reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        out_bytes_reg <= 24'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3]) begin
                    out_bytes_reg[23:16] <= in; // store first byte
                    state <= 2'b01; // move to BYTE1 state
                end
            end
            2'b01: begin // BYTE1 state
                out_bytes_reg[15:8] <= in; // store second byte
                state <= 2'b10; // move to BYTE2 state
            end
            2'b10: begin // BYTE2 state
                out_bytes_reg[7:0] <= in; // store third byte
                state <= 2'b11; // move to DONE state
            end
            2'b11: begin // DONE state
                done_reg <= 1'b1;
                state <= 2'b00; // return to IDLE state
            end
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule