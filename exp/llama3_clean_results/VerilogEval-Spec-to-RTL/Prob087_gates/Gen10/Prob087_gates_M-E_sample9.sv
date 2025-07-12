// Define the lookup table
module TopModule(
    input  logic a,
    input  logic b,
    output logic out_and,
    output logic out_or,
    output logic out_xor,
    output logic out_nand,
    output logic out_nor,
    output logic out_xnor,
    output logic out_anotb
);

    // Lookup table for output values
    always @(*) begin
        case ({a, b})
            2'b00: begin
                out_and = 0;
                out_or = 0;
                out_xor = 0;
                out_nand = 1;
                out_nor = 1;
                out_xnor = 1;
                out_anotb = 0;
            end
            2'b01: begin
                out_and = 0;
                out_or = 1;
                out_xor = 1;
                out_nand = 1;
                out_nor = 0;
                out_xnor = 0;
                out_anotb = 0;
            end
            2'b10: begin
                out_and = 0;
                out_or = 1;
                out_xor = 1;
                out_nand = 1;
                out_nor = 0;
                out_xnor = 0;
                out_anotb = 1;
            end
            2'b11: begin
                out_and = 1;
                out_or = 1;
                out_xor = 0;
                out_nand = 0;
                out_nor = 0;
                out_xnor = 1;
                out_anotb = 0;
            end
        endcase
    end

endmodule