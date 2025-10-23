module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Calculate the starting bit position based on sel
    wire [9:0] start_bit = sel * 4;

    // Assign out by shifting and masking in
    assign out = in[start_bit + 3 : start_bit];

endmodule