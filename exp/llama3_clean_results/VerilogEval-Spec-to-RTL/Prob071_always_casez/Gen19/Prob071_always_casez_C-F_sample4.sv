module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    reg [2:0] pos_reg;

    always @(*) begin
        case (1'b1)
            in[0]: pos_reg = 3'd0;
            in[1]: pos_reg = 3'd1;
            in[2]: pos_reg = 3'd2;
            in[3]: pos_reg = 3'd3;
            in[4]: pos_reg = 3'd4;
            in[5]: pos_reg = 3'd5;
            in[6]: pos_reg = 3'd6;
            in[7]: pos_reg = 3'd7;
            default: pos_reg = 3'd0;
        endcase
    end

    assign pos = pos_reg;

endmodule