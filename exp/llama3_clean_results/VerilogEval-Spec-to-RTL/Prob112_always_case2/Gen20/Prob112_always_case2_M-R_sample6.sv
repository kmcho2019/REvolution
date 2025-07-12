module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

reg [1:0] pos_reg;

always @(*) begin
    case (1'b1)
        in[3]: pos_reg = 2'b11;
        in[2]: pos_reg = 2'b10;
        in[1]: pos_reg = 2'b01;
        in[0]: pos_reg = 2'b00;
        default: pos_reg = 2'b00;
    endcase
end

assign pos = pos_reg;

endmodule