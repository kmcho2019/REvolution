module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

reg [1:0] pos_reg;

always @(*) begin
    pos_reg = 2'b00;
    if (in[3]) pos_reg = 2'b11;
    else if (in[2]) pos_reg = 2'b10;
    else if (in[1]) pos_reg = 2'b01;
    else if (in[0]) pos_reg = 2'b00;
    pos = pos_reg;
end

endmodule