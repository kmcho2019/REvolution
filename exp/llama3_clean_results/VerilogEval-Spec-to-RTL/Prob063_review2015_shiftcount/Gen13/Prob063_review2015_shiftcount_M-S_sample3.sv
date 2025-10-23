module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg = 4'b0;

always @(posedge clk) begin
    case ({shift_ena, count_ena})
        2'b01: // shift_ena is high
            q_reg <= {data, q_reg[3:1]};
        2'b10: // count_ena is high
            q_reg <= (q_reg == 4'b0) ? 4'b0 : q_reg - 1;
        default:
            q_reg <= q_reg;
    endcase
end

assign q = q_reg;

endmodule