module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Calculate the starting bit position (0-1020 in steps of 4)
    wire [9:0] start_bit = {sel, 2'b00}; // sel * 4
    
    // Extract the 4-bit output using circular buffer approach
    assign out = in[(start_bit + 3) % 1024 -: 4];

endmodule