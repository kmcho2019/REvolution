module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Calculate the starting bit position directly
    wire [9:0] bit_pos = {sel, 2'b00}; // Multiply by 4 (sel * 4)
    
    // Directly select the 4-bit output
    assign out = in[bit_pos +: 4];

endmodule