module TopModule (
    input  [31:0] data_in,    // Input data (MSB first: [byte3, byte2, byte1, byte0])
    output [31:0] data_out    // Output data (LSB first: [byte0, byte1, byte2, byte3])
);
    // Byte width parameter for flexibility (could be changed if module is reused)
    localparam BYTE_WIDTH = 8;
    
    // Reverse byte order by concatenating bytes in reverse sequence
    assign data_out = {data_in[0*BYTE_WIDTH +: BYTE_WIDTH],   // byte0 (LSB)
                       data_in[1*BYTE_WIDTH +: BYTE_WIDTH],  // byte1
                       data_in[2*BYTE_WIDTH +: BYTE_WIDTH],  // byte2
                       data_in[3*BYTE_WIDTH +: BYTE_WIDTH]}; // byte3 (MSB)
endmodule