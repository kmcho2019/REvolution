module TopModule (
    input  [31:0] in,
    output [31:0] out
);

localparam BYTE_WIDTH = 8;
localparam BYTE_COUNT = 4;

assign out = {in[BYTE_WIDTH*0 +: BYTE_WIDTH],
              in[BYTE_WIDTH*1 +: BYTE_WIDTH],
              in[BYTE_WIDTH*2 +: BYTE_WIDTH],
              in[BYTE_WIDTH*3 +: BYTE_WIDTH]} >> 24
              |
             {in[BYTE_WIDTH*3 +: BYTE_WIDTH],
              in[BYTE_WIDTH*2 +: BYTE_WIDTH],
              in[BYTE_WIDTH*1 +: BYTE_WIDTH],
              in[BYTE_WIDTH*0 +: BYTE_WIDTH]};

assign out = {in[BYTE_WIDTH*3 +: BYTE_WIDTH],
              in[BYTE_WIDTH*2 +: BYTE_WIDTH],
              in[BYTE_WIDTH*1 +: BYTE_WIDTH],
              in[BYTE_WIDTH*0 +: BYTE_WIDTH]};

endmodule