module TopModule(
    input a,
    input b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    always @(*) begin
        case ({a, b})
            2'b00: begin
                out_and = 1'b0;
                out_or = 1'b0;
                out_xor = 1'b0;
                out_nand = 1'b1;
                out_nor = 1'b1;
                out_xnor = 1'b1;
                out_anotb = 1'b0;
            end
            2'b01: begin
                out_and = 1'b0;
                out_or = 1'b1;
                out_xor = 1'b1;
                out_nand = 1'b1;
                out_nor = 1'b0;
                out_xnor = 1'b0;
                out_anotb = 1'b1;
            end
            2'b10: begin
                out_and = 1'b0;
                out_or = 1'b1;
                out_xor = 1'b1;
                out_nand = 1'b1;
                out_nor = 1'b0;
                out_xnor = 1'b0;
                out_anotb = 1'b0;
            end
            2'b11: begin
                out_and = 1'b1;
                out_or = 1'b1;
                out_xor = 1'b0;
                out_nand = 1'b0;
                out_nor = 1'b0;
                out_xnor = 1'b1;
                out_anotb = 1'b0;
            end
        endcase
    end

endmodule