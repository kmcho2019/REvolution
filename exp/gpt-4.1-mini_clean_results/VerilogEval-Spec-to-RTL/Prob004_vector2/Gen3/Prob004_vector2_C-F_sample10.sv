module TopModule (
    input  wire [31:0] in,
    output wire [31:0] out
);

    // Parameters defining byte width and number of bytes in the input/output vectors
    localparam BYTE_WIDTH = 8;
    localparam BYTE_COUNT = 4;

    genvar i;
    generate
        // Reverse the byte order by reassigning each byte from input to output in reverse sequence
        for (i = 0; i < BYTE_COUNT; i = i + 1) begin : byte_reverse
            // Assign output byte i to input byte (BYTE_COUNT-1 - i)
            assign out[(i*BYTE_WIDTH) +: BYTE_WIDTH] = in[((BYTE_COUNT - 1 - i)*BYTE_WIDTH) +: BYTE_WIDTH];
        end
    endgenerate

endmodule