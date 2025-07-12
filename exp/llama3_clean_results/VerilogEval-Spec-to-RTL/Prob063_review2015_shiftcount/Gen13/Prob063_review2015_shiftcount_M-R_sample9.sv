module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg = 4'b0000;

always @(posedge clk) begin
    case (1'b1)
        shift_ena: q_reg <= {data, q_reg[3:1], q_reg[0]};
        count_ena: q_reg <= (q_reg == 4'b0000) ? 4'b1111 : q_reg - 1;
        default: q_reg <= q_reg;
    endcase
end

assign q = q_reg;

endmodule