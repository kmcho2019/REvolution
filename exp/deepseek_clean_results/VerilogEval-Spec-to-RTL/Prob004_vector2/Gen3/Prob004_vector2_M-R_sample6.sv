module TopModule (
    input  [31:0] in,    // Input word (4 bytes: [byte3, byte2, byte1, byte0])
    output reg [31:0] out    // Output word (bytes reversed: [byte0, byte1, byte2, byte3])
);
    // Reverse byte order using an always block
    always @(*) begin
        out[7:0]   = in[31:24];  // byte3 -> byte0
        out[15:8]  = in[23:16];  // byte2 -> byte1
        out[23:16] = in[15:8];   // byte1 -> byte2
        out[31:24] = in[7:0];    // byte0 -> byte3
    end
endmodule