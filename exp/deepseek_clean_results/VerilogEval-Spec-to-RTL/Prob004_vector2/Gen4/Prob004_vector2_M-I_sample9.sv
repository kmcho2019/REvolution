module TopModule (
    input  [31:0] input_word,    // Input word: [MSB_Byte3][Byte2][Byte1][LSB_Byte0]
    output [31:0] reversed_word  // Output word: [LSB_Byte0][Byte1][Byte2][MSB_Byte3]
);
    localparam BYTE_WIDTH = 8;  // Each byte is 8 bits wide
    
    // Reverse byte order by concatenating bytes in reverse sequence
    assign reversed_word = {input_word[0*BYTE_WIDTH +: BYTE_WIDTH],   // LSB Byte 0
                           input_word[1*BYTE_WIDTH +: BYTE_WIDTH],    // Byte 1
                           input_word[2*BYTE_WIDTH +: BYTE_WIDTH],    // Byte 2
                           input_word[3*BYTE_WIDTH +: BYTE_WIDTH]};   // MSB Byte 3
endmodule