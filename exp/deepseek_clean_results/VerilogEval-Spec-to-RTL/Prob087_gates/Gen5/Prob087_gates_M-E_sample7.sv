module TopModule (
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

    // Combine inputs into a 2-bit selector
    wire [1:0] sel = {a, b};

    // Use case statement to generate all outputs
    always @(*) begin
        case (sel)
            2'b00: begin
                {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = 
                    7'b0_0_0_1_1_1_0;
            end
            2'b01: begin
                {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = 
                    7'b0_1_1_1_0_0_0;
            end
            2'b10: begin
                {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = 
                    7'b0_1_1_1_0_0_1;
            end
            2'b11: begin
                {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = 
                    7'b1_1_0_0_0_1_0;
            end
        endcase
    end

endmodule