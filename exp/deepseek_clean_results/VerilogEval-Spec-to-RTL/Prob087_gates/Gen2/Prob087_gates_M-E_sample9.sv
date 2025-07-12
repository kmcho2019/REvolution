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

    // Pack all outputs into a 7-bit vector for case statement
    reg [6:0] outputs;
    
    always @(*) begin
        case ({a, b})
            2'b00: outputs = 7'b0001101;
            2'b01: outputs = 7'b0110010;
            2'b10: outputs = 7'b1010100;
            2'b11: outputs = 7'b1100011;
            default: outputs = 7'b0000000;
        endcase
    end

    // Unpack the outputs
    assign {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = outputs;

endmodule