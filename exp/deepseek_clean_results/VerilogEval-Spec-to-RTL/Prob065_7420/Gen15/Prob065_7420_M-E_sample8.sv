module TopModule (
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);

    // 4-input LUT implementation of NAND gate
    function lut4_nand;
        input [3:0] in;
        reg [15:0] lut = 16'b1111_1111_1111_1110; // NAND truth table
        begin
            lut4_nand = lut[in];
        end
    endfunction

    // First NAND gate using LUT
    assign p1y = lut4_nand({p1a, p1b, p1c, p1d});

    // Second NAND gate using LUT
    assign p2y = lut4_nand({p2a, p2b, p2c, p2d});

endmodule