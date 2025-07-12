module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    localparam BYTE_WIDTH = 8;
    localparam BYTE_COUNT = 4;

    // Intermediate array of bytes extracted from input
    wire [BYTE_WIDTH-1:0] bytes [0:BYTE_COUNT-1];

    genvar i;
    generate
        for (i = 0; i < BYTE_COUNT; i = i + 1) begin : extract_bytes
            assign bytes[i] = in[(BYTE_COUNT - 1 - i)*BYTE_WIDTH +: BYTE_WIDTH];
        end
    endgenerate

    // Concatenate the bytes in reverse order for output
    assign out = {bytes[0], bytes[1], bytes[2], bytes[3]};

endmodule