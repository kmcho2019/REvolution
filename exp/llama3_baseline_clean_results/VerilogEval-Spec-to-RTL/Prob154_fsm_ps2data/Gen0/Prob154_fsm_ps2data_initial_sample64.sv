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

initial state = 2'b00;
initial out_bytes_reg = 24'b0;
initial done_reg = 1'b0;

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        out_bytes_reg <= 24'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3]) begin
                    byte1 <= in;
                    state <= 2'b01;
                end
            end
            2'b01: begin // BYTE1
                byte2 <= in;
                state <= 2'b10;
            end
            2'b10: begin // BYTE2
                byte3 <= in;
                state <= 2'b11;
            end
            2'b11: begin // DONE
                out_bytes_reg <= {byte1, byte2, byte3};
                done_reg <= 1'b1;
                state <= 2'b00;
            end
            default: state <= 2'b00;
        endcase
        if (state == 2'b11) begin
            out_bytes_reg <= {byte1, byte2, byte3};
            done_reg <= 1'b1;
        end else begin
            done_reg <= 1'b0;
        end
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule