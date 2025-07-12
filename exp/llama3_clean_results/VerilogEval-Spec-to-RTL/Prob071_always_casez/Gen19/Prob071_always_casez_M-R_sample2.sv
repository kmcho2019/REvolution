module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    reg [2:0] pos_reg;

    always @(*) begin
        casez (in)
            8'b1??????? : pos_reg = 3'd7;
            8'b01?????? : pos_reg = 3'd6;
            8'b001????? : pos_reg = 3'd5;
            8'b0001???? : pos_reg = 3'd4;
            8'b00001??? : pos_reg = 3'd3;
            8'b000001?? : pos_reg = 3'd2;
            8'b0000001? : pos_reg = 3'd1;
            8'b00000001 : pos_reg = 3'd0;
            default      : pos_reg = 3'd0;
        endcase
    end

    assign pos = pos_reg;

endmodule