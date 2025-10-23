module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    reg [2:0] pos_reg; // internal register for pos

    always @(*) begin
        casez (in)
            8'b00000001: pos_reg = 3'd0;
            8'b00000010: pos_reg = 3'd1;
            8'b00000100: pos_reg = 3'd2;
            8'b00001000: pos_reg = 3'd3;
            8'b00010000: pos_reg = 3'd4;
            8'b00100000: pos_reg = 3'd5;
            8'b01000000: pos_reg = 3'd6;
            8'b10000000: pos_reg = 3'd7;
            default: pos_reg = 3'd0; // no '1' bits found
        endcase
    end

    assign pos = pos_reg;

endmodule