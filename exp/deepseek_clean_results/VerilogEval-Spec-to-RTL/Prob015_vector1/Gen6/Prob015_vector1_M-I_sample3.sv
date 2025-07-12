module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    localparam BYTE_WIDTH = 8;
    localparam WORD_WIDTH = 16;

    // Extract upper byte (bits [15:8])
    assign out_hi = in[WORD_WIDTH-1:BYTE_WIDTH];
    
    // Extract lower byte (bits [7:0])
    assign out_lo = in[BYTE_WIDTH-1:0];

endmodule