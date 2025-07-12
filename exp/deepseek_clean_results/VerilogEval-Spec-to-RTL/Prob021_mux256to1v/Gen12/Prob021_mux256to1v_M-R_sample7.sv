module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Calculate the starting bit position directly
    wire [9:0] start_bit = {sel, 2'b00}; // sel * 4

    // Select the 4-bit output using variable part-select
    assign out = in[start_bit +: 4];

endmodule