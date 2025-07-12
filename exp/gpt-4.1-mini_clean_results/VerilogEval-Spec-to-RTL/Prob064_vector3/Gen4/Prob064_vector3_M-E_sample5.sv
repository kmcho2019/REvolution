module TopModule(
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Concatenate all inputs into a 30-bit vector
    wire [29:0] combined = {a, b, c, d, e, f};
    // Append two '1' bits at LSB to get 32 bits
    wire [31:0] combined_ext = {combined, 2'b11};

    // Distribute bits in groups of 4 bits in an interleaved pattern
    // Each output takes every 4 bits starting from different offsets:
    // w: bits [31:28], [23:20], [15:12], [7:4]
    // x: bits [27:24], [19:16], [11:8],  [3:0]
    // y: bits [26:22], etc. (adjusting for 8 bits total)
    // To simplify, pick bits at intervals of 4 starting at different offsets

    assign w = {
        combined_ext[31], combined_ext[27], combined_ext[23], combined_ext[19],
        combined_ext[15], combined_ext[11], combined_ext[7],  combined_ext[3]
    };

    assign x = {
        combined_ext[30], combined_ext[26], combined_ext[22], combined_ext[18],
        combined_ext[14], combined_ext[10], combined_ext[6],  combined_ext[2]
    };

    assign y = {
        combined_ext[29], combined_ext[25], combined_ext[21], combined_ext[17],
        combined_ext[13], combined_ext[9],  combined_ext[5],  combined_ext[1]
    };

    assign z = {
        combined_ext[28], combined_ext[24], combined_ext[20], combined_ext[16],
        combined_ext[12], combined_ext[8],  combined_ext[4],  combined_ext[0]
    };

endmodule