module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Define word width and count
    localparam WORD_WIDTH = 4;
    localparam WORD_COUNT = 256;

    // Unpack the input vector into an array of 256 4-bit words
    wire [WORD_WIDTH-1:0] words [0:WORD_COUNT-1];

    genvar i;
    generate
        for (i = 0; i < WORD_COUNT; i = i + 1) begin : unpack_words
            assign words[i] = in[i*WORD_WIDTH +: WORD_WIDTH];
        end
    endgenerate

    // Directly index the words array using sel
    assign out = words[sel];

endmodule