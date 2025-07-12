module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    reg [2:0] pos_reg;

    always @(*) begin
        casez (in)
            8'b10000000: pos_reg = 3'b111;
            8'b01000000: pos_reg = 3'b110;
            8'b00100000: pos_reg = 3'b101;
            8'b00010000: pos_reg = 3'b100;
            8'b00001000: pos_reg = 3'b011;
            8'b00000100: pos_reg = 3'b010;
            8'b00000010: pos_reg = 3'b001;
            8'b00000001: pos_reg = 3'b000;
            default: pos_reg = 3'b000;
        endcase
    end

    assign pos = pos_reg;

endmodule