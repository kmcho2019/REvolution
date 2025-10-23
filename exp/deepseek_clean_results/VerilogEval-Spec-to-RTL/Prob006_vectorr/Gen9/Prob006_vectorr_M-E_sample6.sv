module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // 256x8 ROM containing all possible reversed 8-bit patterns
    reg [7:0] reversal_rom [0:255];
    
    // Initialize ROM with reversed patterns
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            reversal_rom[i] = {
                i[0], i[1], i[2], i[3],
                i[4], i[5], i[6], i[7]
            };
        end
    end

    // Output is simply the ROM lookup
    assign out = reversal_rom[in];

endmodule