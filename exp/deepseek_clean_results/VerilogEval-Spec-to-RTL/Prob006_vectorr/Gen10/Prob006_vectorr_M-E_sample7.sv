module TopModule (
    input [7:0] in,
    output [7:0] out
);
    // Pre-computed 8-bit reversal LUT
    reg [7:0] reversal_rom [0:255];
    
    initial begin
        for (integer i = 0; i < 256; i = i + 1) begin
            reversal_rom[i] = {
                i[0], i[1], i[2], i[3], 
                i[4], i[5], i[6], i[7]
            };
        end
    end
    
    assign out = reversal_rom[in];
endmodule