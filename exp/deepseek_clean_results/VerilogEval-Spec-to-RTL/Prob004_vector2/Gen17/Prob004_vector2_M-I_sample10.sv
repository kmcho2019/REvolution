module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Parameterized byte width (default 8 bits)
    parameter BYTE_WIDTH = 8;
    localparam NUM_BYTES = 32/BYTE_WIDTH;
    
    // Direct reversed byte order concatenation
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};
endmodule