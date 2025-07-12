module TopModule(
    input [1023:0] in,  // 1024-bit input vector
    input [7:0] sel,    // 8-bit select signal
    output [3:0] out     // 4-bit output
);

    // Calculate the starting index of the selected 4-bit group based on 'sel'.
    // Since each selection corresponds to a 4-bit group, multiply sel by 4.
    wire [9:0] index = {2'b0, sel} * 4'd4; // ensuring 10-bit result

    // Extract the selected 4 bits from 'in' and assign them to 'out'.
    // The '+:' operator is used for variable-part-select, allowing us to dynamically select 4 bits starting from 'index'.
    assign out = in[index +: 4];

endmodule