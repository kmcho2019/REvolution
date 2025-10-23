module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Calculate the starting bit position of the selected 4-bit chunk
    wire [9:0] start_bit = {sel, 2'b00};  // Multiply sel by 4 (left shift by 2 bits)
    
    // Select the 4-bit output based on the calculated starting bit position
    assign out = in[start_bit +: 4];
endmodule