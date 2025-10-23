module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

reg out_sop_reg;
reg out_pos_reg;

always @(a, b, c, d) begin
    case ({a, b, c, d})
        4'b0000: begin out_sop_reg = 1'b0; out_pos_reg = 1'b0; end
        4'b0001: begin out_sop_reg = 1'b0; out_pos_reg = 1'b0; end
        4'b0010: begin out_sop_reg = 1'b1; out_pos_reg = 1'b1; end
        4'b0011: begin out_sop_reg = 1'b0; out_pos_reg = 1'b1; end
        4'b0100: begin out_sop_reg = 1'b0; out_pos_reg = 1'b0; end
        4'b0101: begin out_sop_reg = 1'b0; out_pos_reg = 1'b0; end
        4'b0110: begin out_sop_reg = 1'b0; out_pos_reg = 1'b0; end
        4'b0111: begin out_sop_reg = 1'b1; out_pos_reg = 1'b1; end
        4'b1000: begin out_sop_reg = 1'b0; out_pos_reg = 1'b1; end
        4'b1001: begin out_sop_reg = 1'b0; out_pos_reg = 1'b0; end
        4'b1010: begin out_sop_reg = 1'b0; out_pos_reg = 1'b0; end
        4'b1011: begin out_sop_reg = 1'b0; out_pos_reg = 1'b1; end
        4'b1100: begin out_sop_reg = 1'b0; out_pos_reg = 1'b0; end
        4'b1101: begin out_sop_reg = 1'b0; out_pos_reg = 1'b0; end
        4'b1110: begin out_sop_reg = 1'b0; out_pos_reg = 1'b0; end
        4'b1111: begin out_sop_reg = 1'b1; out_pos_reg = 1'b1; end
        default: begin out_sop_reg = 1'b0; out_pos_reg = 1'b1; end
    endcase
end

assign out_sop = out_sop_reg;
assign out_pos = out_pos_reg;

endmodule