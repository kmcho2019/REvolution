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
    always @(*) begin
        case ({p1a, p1b, p1c, p1d})
            4'b1111: p1y = 1'b0;
            default: p1y = 1'b1;
        endcase
    end

    // Second 4-input NAND implemented as LUT
    always @(*) begin
        case ({p2a, p2b, p2c, p2d})
            4'b1111: p2y = 1'b0;
            default: p2y = 1'b1;
        endcase
    end

endmodule