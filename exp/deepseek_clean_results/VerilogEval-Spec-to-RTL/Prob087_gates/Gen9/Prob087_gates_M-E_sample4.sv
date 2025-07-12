module TopModule (
    input  a, b,
    output out_and, out_or, out_xor,
    output out_nand, out_nor, out_xnor,
    output out_anotb
);

    // 4x7 ROM containing all output combinations
    reg [6:0] rom [0:3];
    
    initial begin
        // Address 00 (a=0, b=0)
        rom[0] = 7'b0_0_0_1_1_1_0;
        // Address 01 (a=0, b=1)
        rom[1] = 7'b0_1_1_1_0_0_0;
        // Address 10 (a=1, b=0)
        rom[2] = 7'b0_1_1_1_0_0_1;
        // Address 11 (a=1, b=1)
        rom[3] = 7'b1_1_0_0_0_1_0;
    end
    
    // Output assignments
    wire [6:0] outputs = rom[{a,b}];
    assign {out_and, out_or, out_xor, 
            out_nand, out_nor, out_xnor,
            out_anotb} = outputs;

endmodule