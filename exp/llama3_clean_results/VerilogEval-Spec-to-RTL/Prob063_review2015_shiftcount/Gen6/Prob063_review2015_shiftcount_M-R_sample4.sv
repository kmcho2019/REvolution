module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge clk) begin
    case ({shift_ena, count_ena})
        2'b01: begin
            if (q_reg == 4'b0) begin
                q_reg <= 4'b0;
            end else begin
                q_reg <= q_reg - 1;
            end
        end
        2'b10: begin
            q_reg <= {data, q_reg[3:1]};
        end
        default: begin
            q_reg <= q_reg;
        end
    endcase
end

assign q = q_reg;

endmodule