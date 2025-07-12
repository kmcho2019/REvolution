module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    reg [0:0] and_lut [0:15];
    reg [0:0] or_lut [0:15];
    reg [0:0] xor_lut [0:15];

    initial begin
        // Initialize AND LUT
        and_lut[0] = 0;
        and_lut[1] = 0;
        and_lut[2] = 0;
        and_lut[3] = 0;
        and_lut[4] = 0;
        and_lut[5] = 0;
        and_lut[6] = 0;
        and_lut[7] = 0;
        and_lut[8] = 0;
        and_lut[9] = 0;
        and_lut[10] = 0;
        and_lut[11] = 0;
        and_lut[12] = 0;
        and_lut[13] = 0;
        and_lut[14] = 0;
        and_lut[15] = 1;

        // Initialize OR LUT
        or_lut[0] = 0;
        or_lut[1] = 1;
        or_lut[2] = 1;
        or_lut[3] = 1;
        or_lut[4] = 1;
        or_lut[5] = 1;
        or_lut[6] = 1;
        or_lut[7] = 1;
        or_lut[8] = 1;
        or_lut[9] = 1;
        or_lut[10] = 1;
        or_lut[11] = 1;
        or_lut[12] = 1;
        or_lut[13] = 1;
        or_lut[14] = 1;
        or_lut[15] = 1;

        // Initialize XOR LUT
        xor_lut[0] = 0;
        xor_lut[1] = 1;
        xor_lut[2] = 1;
        xor_lut[3] = 0;
        xor_lut[4] = 1;
        xor_lut[5] = 0;
        xor_lut[6] = 0;
        xor_lut[7] = 1;
        xor_lut[8] = 1;
        xor_lut[9] = 0;
        xor_lut[10] = 0;
        xor_lut[11] = 1;
        xor_lut[12] = 0;
        xor_lut[13] = 1;
        xor_lut[14] = 1;
        xor_lut[15] = 0;
    end

    always @(*) begin
        out_and = and_lut[in];
        out_or = or_lut[in];
        out_xor = xor_lut[in];
    end

endmodule