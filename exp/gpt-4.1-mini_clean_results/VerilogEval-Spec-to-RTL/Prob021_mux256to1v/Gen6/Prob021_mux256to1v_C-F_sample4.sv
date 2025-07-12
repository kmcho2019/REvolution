module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Parameters for word width and total number of words
    localparam WORD_WIDTH = 4;
    localparam WORD_COUNT = 256;

    // Represent 'in' as an array of 256 elements, each 4 bits wide
    wire [WORD_WIDTH-1:0] in_array [0:WORD_COUNT-1];

    genvar i;
    generate
        for (i = 0; i < WORD_COUNT; i = i + 1) begin : unpack_input
            // Slice 4 bits per word: bits [4*i +3 : 4*i]
            assign in_array[i] = in[i*WORD_WIDTH +: WORD_WIDTH];
        end
    endgenerate

    // Output the selected 4-bit word
    assign out = in_array[sel];

endmodule