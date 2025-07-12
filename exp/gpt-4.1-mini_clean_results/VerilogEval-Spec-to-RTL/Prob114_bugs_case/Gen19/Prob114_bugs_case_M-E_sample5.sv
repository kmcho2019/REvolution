module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output       valid
);

    // ROM: 256 entries of 5 bits each: [valid_bit(4), digit(3:0)]
    reg [4:0] decode_rom [0:255];

    initial begin
        integer i;
        // Default all entries to invalid, digit=0
        for (i = 0; i < 256; i = i + 1) begin
            decode_rom[i] = 5'b00000; // valid=0, digit=0
        end

        // Set valid entries:
        decode_rom[8'h45] = 5'b10000; // 0
        decode_rom[8'h16] = 5'b10001; // 1
        decode_rom[8'h1E] = 5'b10010; // 2
        decode_rom[8'h26] = 5'b10011; // 3
        decode_rom[8'h25] = 5'b10100; // 4
        decode_rom[8'h2E] = 5'b10101; // 5
        decode_rom[8'h36] = 5'b10110; // 6
        decode_rom[8'h3D] = 5'b10111; // 7
        decode_rom[8'h3E] = 5'b11000; // 8
        decode_rom[8'h46] = 5'b11001; // 9
    end

    wire [4:0] decode_word = decode_rom[code];

    assign valid = decode_word[4];
    assign out = decode_word[3:0];

endmodule