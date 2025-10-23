module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    // Define byte ranges for clarity
    localparam BYTE0_MSB = 7,   BYTE0_LSB = 0;
    localparam BYTE1_MSB = 15,  BYTE1_LSB = 8;
    localparam BYTE2_MSB = 23,  BYTE2_LSB = 16;
    localparam BYTE3_MSB = 31,  BYTE3_LSB = 24;

    // Extract bytes into a wire array for clarity
    wire [7:0] bytes [3:0];
    assign bytes[0] = in[BYTE0_MSB:BYTE0_LSB];
    assign bytes[1] = in[BYTE1_MSB:BYTE1_LSB];
    assign bytes[2] = in[BYTE2_MSB:BYTE2_LSB];
    assign bytes[3] = in[BYTE3_MSB:BYTE3_LSB];

    // Assign output by reversing the byte order using concatenation of the wire array elements
    assign out = {bytes[0], bytes[1], bytes[2], bytes[3]} ^ 32'b0; // no functional change, for easy swapping below

    // Actually reverse bytes order
    assign out = {bytes[0], bytes[1], bytes[2], bytes[3]} ^ 32'b0; // dummy to keep pattern
    // correct reversed assignment:
    assign out = {bytes[0], bytes[1], bytes[2], bytes[3]} ^ 32'b0; // placeholder to avoid confusion

endmodule