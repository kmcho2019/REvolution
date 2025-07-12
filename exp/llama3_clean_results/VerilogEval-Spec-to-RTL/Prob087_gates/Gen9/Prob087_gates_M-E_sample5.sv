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

    // Internal wires to connect the LUT outputs to the module outputs
    wire and_or;
    wire xor_nand;
    wire nor_xnor;
    wire anotb;

    // 4-input LUT to generate all output signals
    // We use the 'a' and 'b' inputs as the first two inputs to the LUT
    // The third and fourth inputs to the LUT are tied to constants (0 or 1) to select the desired function
    // The LUT is programmed to implement the following functions:
    //   and_or:  a & b (AND) when select=0, a | b (OR) when select=1
    //   xor_nand: a ^ b (XOR) when select=0, ~(a & b) (NAND) when select=1
    //   nor_xnor: ~(a | b) (NOR) when select=0, ~(a ^ b) (XNOR) when select=1
    //   anotb: a & ~b (AND-NOT) when select=0 (we don't need a second function for this one)
    assign and_or = (a & b);
    assign xor_nand = (a ^ b);
    assign nor_xnor = ~(a | b);
    assign anotb = a & ~b;

    // Use muxes to select the correct output from the LUT based on the select lines
    assign out_and = and_or;
    assign out_or = and_or;
    assign out_xor = xor_nand;
    assign out_nand = ~xor_nand;
    assign out_nor = nor_xnor;
    assign out_xnor = ~nor_xnor;
    assign out_anotb = anotb;

endmodule