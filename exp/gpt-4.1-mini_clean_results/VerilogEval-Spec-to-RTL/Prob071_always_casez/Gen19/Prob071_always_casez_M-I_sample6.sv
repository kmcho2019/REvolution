module TopModule (
    input  [7:0] in,
    output [2:0] pos
);

    wire [1:0] half_pos;   // Position of half (0 for bits[3:0], 1 for bits[7:4])
    wire       half_valid; // Indicates if any bit in the input is set
    wire [2:0] low_pos;    // Position inside lower half bits[3:0]
    wire [2:0] high_pos;   // Position inside higher half bits[7:4]

    // 4-bit priority encoder for lower half (bits 3:0)
    wire [2:0] encode_4bit_low;
    assign encode_4bit_low = (in[0]) ? 3'd0 :
                            (in[1]) ? 3'd1 :
                            (in[2]) ? 3'd2 :
                            (in[3]) ? 3'd3 : 3'd0;
    wire low_valid = |in[3:0];

    // 4-bit priority encoder for upper half (bits 7:4)
    wire [2:0] encode_4bit_high;
    assign encode_4bit_high = (in[4]) ? 3'd0 :
                             (in[5]) ? 3'd1 :
                             (in[6]) ? 3'd2 :
                             (in[7]) ? 3'd3 : 3'd0;
    wire high_valid = |in[7:4];

    // 1-bit priority encoder to select which half has the first set bit
    assign half_valid = low_valid | high_valid;
    assign half_pos = low_valid ? 2'd0 :
                      high_valid ? 2'd1 : 2'd0;

    // Assign pos based on half_pos
    assign pos = half_valid ? 
                  (half_pos == 2'd0 ? encode_4bit_low :
                                      (encode_4bit_high + 3'd4))
                : 3'd0;

endmodule