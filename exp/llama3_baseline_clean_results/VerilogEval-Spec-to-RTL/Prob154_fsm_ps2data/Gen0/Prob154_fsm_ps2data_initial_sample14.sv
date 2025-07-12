module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [7:0] byte1, byte2, byte3;
reg [23:0] out_bytes_reg;
reg done_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        out_bytes_reg <= 24'd0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01; // BYTE1 state
                end
            end
            2'b01: begin // BYTE1 state
                byte2 <= in;
                state <= 2'b10; // BYTE2 state
            end
            2'b10: begin // BYTE2 state
                byte3 <= in;
                out_bytes_reg <= {byte1, byte2, byte3};
                done_reg <= 1'b1;
                state <= 2'b00; // IDLE state
            end
            default: state <= 2'b00; // IDLE state
        endcase
        if (done_reg) begin
            done_reg <= 1'b0;
        end
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule