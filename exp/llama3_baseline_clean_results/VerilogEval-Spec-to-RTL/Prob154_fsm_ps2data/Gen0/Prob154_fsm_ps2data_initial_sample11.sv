module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg done_reg;
reg [1:0] state_reg; // 0: IDLE, 1: BYTE_1, 2: BYTE_2, 3: DONE

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 0; // IDLE
        out_bytes_reg <= 0;
        done_reg <= 0;
    end else begin
        case (state_reg)
            0: begin // IDLE
                if (in[3] == 1) begin
                    state_reg <= 1; // BYTE_1
                    out_bytes_reg[23:16] <= in;
                end
            end
            1: begin // BYTE_1
                state_reg <= 2; // BYTE_2
                out_bytes_reg[15:8] <= in;
            end
            2: begin // BYTE_2
                state_reg <= 3; // DONE
                out_bytes_reg[7:0] <= in;
            end
            3: begin // DONE
                state_reg <= 0; // IDLE
                done_reg <= 1;
            end
            default: state_reg <= 0; // IDLE
        endcase
        if (state_reg!= 3) begin
            done_reg <= 0;
        end
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule