module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [7:0] byte1;
reg [7:0] byte2;
reg [23:0] out_bytes_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        done_reg <= 1'b0;
        out_bytes_reg <= 24'd0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3]) begin
                    state <= 2'b01; // BYTE1 state
                    byte1 <= in;
                end
            end
            2'b01: begin // BYTE1 state
                state <= 2'b10; // BYTE2 state
                byte2 <= in;
            end
            2'b10: begin // BYTE2 state
                state <= 2'b00; // IDLE state
                out_bytes_reg <= {in, byte2, byte1};
                done_reg <= 1'b1;
            end
            default: state <= 2'b00;
        endcase
        if (state != 2'b10) begin
            done_reg <= 1'b0;
        end
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule