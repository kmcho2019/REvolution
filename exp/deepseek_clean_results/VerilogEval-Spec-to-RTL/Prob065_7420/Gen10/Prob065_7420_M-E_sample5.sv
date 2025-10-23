module LUT4NAND (
    input [3:0] in,
    output reg out
);
    // LUT implementation of 4-input NAND
    always @(*) begin
        case(in)
            4'b0000: out = 1'b1;
            4'b0001: out = 1'b1;
            4'b0010: out = 1'b1;
            4'b0011: out = 1'b1;
            4'b0100: out = 1'b1;
            4'b0101: out = 1'b1;
            4'b0110: out = 1'b1;
            4'b0111: out = 1'b1;
            4'b1000: out = 1'b1;
            4'b1001: out = 1'b1;
            4'b1010: out = 1'b1;
            4'b1011: out = 1'b1;
            4'b1100: out = 1'b1;
            4'b1101: out = 1'b1;
            4'b1110: out = 1'b1;
            4'b1111: out = 1'b0;
            default: out = 1'b1;
        endcase
    end
endmodule

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

    // First 4-input NAND implemented as LUT
    LUT4NAND gate1 (
        .in({p1a, p1b, p1c, p1d}),
        .out(p1y)
    );

    // Second 4-input NAND implemented as LUT
    LUT4NAND gate2 (
        .in({p2a, p2b, p2c, p2d}),
        .out(p2y)
    );

endmodule