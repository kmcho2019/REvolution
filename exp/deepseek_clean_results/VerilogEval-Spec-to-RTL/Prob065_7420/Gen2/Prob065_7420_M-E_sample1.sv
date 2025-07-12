module TopModule (
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output reg p1y,
    output reg p2y
);

    // LUT for first NAND gate
    always @(*) begin
        case ({p1a, p1b, p1c, p1d})
            4'b0000: p1y = 1'b1;
            4'b0001: p1y = 1'b1;
            4'b0010: p1y = 1'b1;
            4'b0011: p1y = 1'b1;
            4'b0100: p1y = 1'b1;
            4'b0101: p1y = 1'b1;
            4'b0110: p1y = 1'b1;
            4'b0111: p1y = 1'b1;
            4'b1000: p1y = 1'b1;
            4'b1001: p1y = 1'b1;
            4'b1010: p1y = 1'b1;
            4'b1011: p1y = 1'b1;
            4'b1100: p1y = 1'b1;
            4'b1101: p1y = 1'b1;
            4'b1110: p1y = 1'b1;
            4'b1111: p1y = 1'b0;
        endcase
    end

    // LUT for second NAND gate
    always @(*) begin
        case ({p2a, p2b, p2c, p2d})
            4'b0000: p2y = 1'b1;
            4'b0001: p2y = 1'b1;
            4'b0010: p2y = 1'b1;
            4'b0011: p2y = 1'b1;
            4'b0100: p2y = 1'b1;
            4'b0101: p2y = 1'b1;
            4'b0110: p2y = 1'b1;
            4'b0111: p2y = 1'b1;
            4'b1000: p2y = 1'b1;
            4'b1001: p2y = 1'b1;
            4'b1010: p2y = 1'b1;
            4'b1011: p2y = 1'b1;
            4'b1100: p2y = 1'b1;
            4'b1101: p2y = 1'b1;
            4'b1110: p2y = 1'b1;
            4'b1111: p2y = 1'b0;
        endcase
    end

endmodule