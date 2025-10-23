module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Calculate the starting bit position of the desired input
    assign out = in[(sel * 4 + 3) : (sel * 4)];

endmodule