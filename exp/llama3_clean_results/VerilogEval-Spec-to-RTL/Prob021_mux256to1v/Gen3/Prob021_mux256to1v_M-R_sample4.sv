module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    // Calculate the starting index of the selected 4-bit group
    wire [9:0] start_index = {2'b0, sel} * 4'd4;

    // Extract the selected 4 bits from 'in' and assign them to 'out'
    assign out = in[start_index + 3 -: 4];

endmodule