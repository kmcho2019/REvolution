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

    // 4-bit LUT covering all possible 2-input logic functions
    wire [15:0] lut;
    assign lut = 16'b0000_0001_0110_1001; // Encodes all needed functions
    
    // Input combination index
    wire [1:0] sel = {a, b};
    
    // Compute all functions in parallel
    assign out_and   = lut[{2'b00, sel}]; // AND pattern at pos 0
    assign out_or    = lut[{2'b01, sel}]; // OR pattern at pos 4
    assign out_xor   = lut[{2'b10, sel}]; // XOR pattern at pos 8
    assign out_nand  = ~lut[{2'b00, sel}]; // Inverted AND
    assign out_nor   = ~lut[{2'b01, sel}]; // Inverted OR
    assign out_xnor  = ~lut[{2'b10, sel}]; // Inverted XOR
    assign out_anotb = lut[{2'b11, sel}]; // A AND-NOT B pattern at pos 12

endmodule