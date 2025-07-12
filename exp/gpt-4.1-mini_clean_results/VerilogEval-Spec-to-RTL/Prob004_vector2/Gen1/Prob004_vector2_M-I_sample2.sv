module TopModule (
    input  wire [31:0] in,
    output wire [31:0] out
);

localparam BYTE_WIDTH = 8;
localparam NUM_BYTES = 4;

genvar i;
wire [31:0] reversed_bytes;

generate
    for (i = 0; i < NUM_BYTES; i = i + 1) begin : byte_reverse
        assign reversed_bytes[(i+1)*BYTE_WIDTH-1 : i*BYTE_WIDTH] = in[(NUM_BYTES - 1 - i + 1)*BYTE_WIDTH - 1 : (NUM_BYTES - 1 - i)*BYTE_WIDTH];
    end
endgenerate

assign out = reversed_bytes;

endmodule