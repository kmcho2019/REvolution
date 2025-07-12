module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

reg out_sop_reg, out_pos_reg;

always @(*) begin
    case ({a, b, c, d})
        2'b0000, 2'b0001, 2'b0100, 2'b0101, 2'b0110, 2'b1000, 2'b1001, 2'b1010, 2'b1011, 2'b1100, 2'b1101: begin
            out_sop_reg = 1'b0;
            out_pos_reg = 1'b1;
        end
        2'b0010, 2'b0111, 2'b1111: begin
            out_sop_reg = 1'b1;
            out_pos_reg = 1'b0;
        end
        default: begin
            out_sop_reg = 1'bx;
            out_pos_reg = 1'bx;
        end
    endcase
end

assign out_sop = out_sop_reg;
assign out_pos = out_pos_reg;

endmodule