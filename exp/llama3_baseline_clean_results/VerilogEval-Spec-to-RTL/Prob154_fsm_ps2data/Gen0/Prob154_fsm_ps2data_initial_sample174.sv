module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg done_reg;
reg [1:0] state_reg; // idle, byte1, byte2, done
reg [7:0] byte1_reg, byte2_reg;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state_reg <= 0; // idle
        done_reg <= 0;
        out_bytes_reg <= 0;
    end else begin
        case(state_reg)
            0: begin // idle
                if(in[3]) begin
                    byte1_reg <= in;
                    state_reg <= 1; // byte1
                end else begin
                    state_reg <= 0; // idle
                end
            end
            1: begin // byte1
                byte2_reg <= in;
                state_reg <= 2; // byte2
            end
            2: begin // byte2
                out_bytes_reg <= {in, byte2_reg, byte1_reg};
                state_reg <= 3; // done
            end
            3: begin // done
                done_reg <= 1;
                state_reg <= 0; // idle
            end
            default: state_reg <= 0;
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = (state_reg == 3) ? 1 : 0;

endmodule