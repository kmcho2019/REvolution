module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    // Directly use 'sel' to select the correct 4 bits from 'in'
    assign out = in[(sel * 4) +: 4];

endmodule