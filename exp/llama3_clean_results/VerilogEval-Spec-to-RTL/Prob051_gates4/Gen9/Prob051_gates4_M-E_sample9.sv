// Define the LUT module with a configurable truth table
module LUT(
    input  [3:0] in,
    output out,
    input  [15:0] truth_table // 16-bit truth table for 4-input LUT
);
    assign out = truth_table[in];
endmodule

// Define the truth tables for the 4-input AND, OR, and XOR gates
`define AND_TRUTH_TABLE 16'b1000_0000_0000_0000
`define OR_TRUTH_TABLE  16'b1111_1111_1111_1110
`define XOR_TRUTH_TABLE 16'b1110_1101_1011_0101

// Top-level module instantiating the LUTs
module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    LUT andLUT(in, out_and, `AND_TRUTH_TABLE);
    LUT orLUT(in, out_or, `OR_TRUTH_TABLE);
    LUT xorLUT(in, out_xor, `XOR_TRUTH_TABLE);
endmodule