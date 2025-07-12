module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    reg [2:0] pos_reg;

    always @(*) begin
        pos_reg = 3'd0;
        if (in[0]) pos_reg = 3'd0;
        else if (in[1]) pos_reg = 3'd1;
        else if (in[2]) pos_reg = 3'd2;
        else if (in[3]) pos_reg = 3'd3;
        else if (in[4]) pos_reg = 3'd4;
        else if (in[5]) pos_reg = 3'd5;
        else if (in[6]) pos_reg = 3'd6;
        else if (in[7]) pos_reg = 3'd7;
    end

    assign pos = pos_reg;

endmodule