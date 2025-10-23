module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Create a double-width buffer to handle wrap-around cases
    wire [2047:0] extended_in = {in, in};
    
    // Calculate the starting bit position (0-1023)
    wire [10:0] start_bit = sel * 4;
    
    // Select the 4-bit window (handles wrap-around automatically)
    assign out = extended_in[start_bit +: 4];

endmodule