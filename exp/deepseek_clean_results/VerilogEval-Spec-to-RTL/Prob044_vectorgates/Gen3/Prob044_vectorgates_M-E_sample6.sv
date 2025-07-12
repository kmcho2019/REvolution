module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // 6-bit LUT for all possible OR combinations (64 entries)
    reg [2:0] or_lut [0:63];
    integer i;
    initial begin
        for (i = 0; i < 64; i = i + 1) begin
            or_lut[i] = (i[5:3] | i[2:0]);
        end
    end

    // Bitwise OR using LUT
    wire [5:0] lut_index = {b, a};
    assign out_or_bitwise = or_lut[lut_index];

    // Logical OR - check if any bit in the result is set
    assign out_or_logical = |out_or_bitwise;

    // NOT operations with bit reversal
    wire [5:0] combined = {b, a};
    wire [5:0] inverted = ~combined;
    assign out_not = {inverted[0], inverted[1], inverted[2], 
                     inverted[3], inverted[4], inverted[5]};

endmodule