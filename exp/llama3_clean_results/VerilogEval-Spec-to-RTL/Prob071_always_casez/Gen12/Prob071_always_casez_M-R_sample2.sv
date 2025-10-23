module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    reg [2:0] pos_reg;

    always @(*)
    begin
        casex (in)
            8'b0, 8'b1: pos_reg = 3'd0;
            8'b10: pos_reg = 3'd1;
            8'b100: pos_reg = 3'd2;
            8'b1000: pos_reg = 3'd3;
            8'b10000: pos_reg = 3'd4;
            8'b100000: pos_reg = 3'd5;
            8'b1000000: pos_reg = 3'd6;
            8'b10000000: pos_reg = 3'd7;
            default: pos_reg = 3'd0;
        endcase
    end

    assign pos = pos_reg;

endmodule