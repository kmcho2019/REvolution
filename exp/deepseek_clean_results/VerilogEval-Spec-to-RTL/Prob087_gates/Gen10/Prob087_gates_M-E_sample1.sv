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

    // Pack all outputs into a 7-bit vector
    wire [6:0] outputs;

    // Truth table implementation using concatenated outputs:
    // Order: [anotb, xnor, nor, nand, xor, or, and]
    assign outputs = ( {a,b} == 2'b00 ) ? 7'b0_1_1_1_0_0_0 :
                    ( {a,b} == 2'b01 ) ? 7'b0_0_0_1_1_1_0 :
                    ( {a,b} == 2'b10 ) ? 7'b1_0_0_1_1_1_0 :
                                         7'b0_0_0_0_0_1_1 ;

    // Unpack the outputs
    assign {out_anotb, out_xnor, out_nor, out_nand, out_xor, out_or, out_and} = outputs;

endmodule