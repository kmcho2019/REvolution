module TopModule (
    input  a,
    input  b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    // 4-entry ROM storing all output combinations
    // Each entry is 7 bits: [and, or, xor, nand, nor, xnor, anotb]
    reg [6:0] rom [0:3];
    
    initial begin
        // Truth table entries
        rom[0] = 7'b000_1110; // a=0, b=0
        rom[1] = 7'b000_1011; // a=0, b=1
        rom[2] = 7'b011_0100; // a=1, b=0
        rom[3] = 7'b111_0000; // a=1, b=1
    end

    // Output assignment
    assign {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = rom[{a,b}];

endmodule