module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [23:0] out_bytes_reg;
reg done_reg;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 2'b00; // IDLE state
        out_bytes_reg <= 24'b0;
        done_reg <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // IDLE state
                if(in[3]) begin
                    out_bytes_reg <= {in, 16'b0};
                    state <= 2'b01; // BYTE1 state
                end
            end
            2'b01: begin // BYTE1 state
                out_bytes_reg <= {out_bytes_reg[15:0], in};
                state <= 2'b10; // BYTE2 state
            end
            2'b10: begin // BYTE2 state
                out_bytes_reg <= {out_bytes_reg[7:0], in, 8'b0};
                state <= 2'b11; // BYTE3 state
                done_reg <= 1'b1;
            end
            2'b11: begin // BYTE3 state
                done_reg <= 1'b0;
                state <= 2'b00; // IDLE state
            end
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule