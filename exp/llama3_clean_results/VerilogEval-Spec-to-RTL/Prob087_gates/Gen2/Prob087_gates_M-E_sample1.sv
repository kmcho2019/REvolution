module TopModule(
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

// Define the LUTs for each output
wire [1:0] inputs;
assign inputs = {a, b};

// AND, OR, XOR, NAND, NOR, XNOR, and AND-NOT LUTs
reg [7:0] lut_and, lut_or, lut_xor, lut_nand, lut_nor, lut_xnor, lut_anotb;

initial begin
    lut_and = 8'b00000001; // AND: 00=0, 01=0, 10=0, 11=1
    lut_or  = 8'b00001111; // OR:  00=0, 01=1, 10=1, 11=1
    lut_xor = 8'b00001010; // XOR: 00=0, 01=1, 10=1, 11=0
    lut_nand = 8'b11111110; // NAND: 00=1, 01=1, 10=1, 11=0
    lut_nor = 8'b10000000; // NOR:  00=1, 01=0, 10=0, 11=0
    lut_xnor = 8'b10000101; // XNOR: 00=1, 01=0, 10=0, 11=1
    lut_anotb = 8'b00100000; // AND-NOT: 00=0, 01=0, 10=1, 11=0
end

// Assign outputs based on LUT values
assign out_and = lut_and[inputs];
assign out_or = lut_or[inputs];
assign out_xor = lut_xor[inputs];
assign out_nand = lut_nand[inputs];
assign out_nor = lut_nor[inputs];
assign out_xnor = lut_xnor[inputs];
assign out_anotb = lut_anotb[inputs];

endmodule