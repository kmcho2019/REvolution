module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // LUT containing all 256 possible 8-bit reversed patterns
    reg [7:0] reverse_lut [0:255];
    
    // Initialize LUT with reversed patterns
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            reverse_lut[i] = {
                i[0], i[1], i[2], i[3], 
                i[4], i[5], i[6], i[7]
            };
        end
    end

    // Output is selected from LUT based on input
    assign out = reverse_lut[in];

endmodule