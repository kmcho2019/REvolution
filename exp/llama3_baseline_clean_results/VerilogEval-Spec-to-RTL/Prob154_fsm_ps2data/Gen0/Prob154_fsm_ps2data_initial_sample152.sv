module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [23:0] out_bytes_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        out_bytes_reg <= 24'd0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3]) begin
                    out_bytes_reg[23:16] <= in;
                    state <= 2'b01; // BYTE1 state
                end
            end
            2'b01: begin // BYTE1 state
                out_bytes_reg[15:8] <= in;
                state <= 2'b10; // BYTE2 state
            end
            2'b10: begin // BYTE2 state
                out_bytes_reg[7:0] <= in;
                done <= 1'b1;
                state <= 2'b00; // IDLE state
            end
            default: begin
                state <= 2'b00; // IDLE state
            end
        endcase
        if (state!= 2'b10) begin
            done <= 1'b0;
        end
    end
end

assign out_bytes = out_bytes_reg;

endmodule