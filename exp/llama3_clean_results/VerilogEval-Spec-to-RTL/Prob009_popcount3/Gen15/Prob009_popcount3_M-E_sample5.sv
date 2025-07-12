module TopModule(
    input [2:0] in,
    output [1:0] out
);

    reg [1:0] lut [7:0];
    initial begin
        lut[0] = 0;  // 000
        lut[1] = 1;  // 001
        lut[2] = 1;  // 010
        lut[3] = 2;  // 011
        lut[4] = 1;  // 100
        lut[5] = 2;  // 101
        lut[6] = 2;  // 110
        lut[7] = 3;  // 111
    end

    assign out = lut[in];

endmodule