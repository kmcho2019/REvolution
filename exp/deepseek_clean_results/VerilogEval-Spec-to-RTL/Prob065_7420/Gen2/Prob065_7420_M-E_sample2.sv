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

    // Function to implement 4-input NAND using LUT approach
    function automatic lut_nand4;
        input a, b, c, d;
        reg [3:0] sel;
        begin
            sel = {a, b, c, d};
            case (sel)
                4'b0000: lut_nand4 = 1'b1;
                4'b0001: lut_nand4 = 1'b1;
                4'b0010: lut_nand4 = 1'b1;
                4'b0011: lut_nand4 = 1'b1;
                4'b0100: lut_nand4 = 1'b1;
                4'b0101: lut_nand4 = 1'b1;
                4'b0110: lut_nand4 = 1'b1;
                4'b0111: lut_nand4 = 1'b1;
                4'b1000: lut_nand4 = 1'b1;
                4'b1001: lut_nand4 = 1'b1;
                4'b1010: lut_nand4 = 1'b1;
                4'b1011: lut_nand4 = 1'b1;
                4'b1100: lut_nand4 = 1'b1;
                4'b1101: lut_nand4 = 1'b1;
                4'b1110: lut_nand4 = 1'b1;
                4'b1111: lut_nand4 = 1'b0;
            endcase
        end
    endfunction

    // Apply LUT to both NAND gates
    assign p1y = lut_nand4(p1a, p1b, p1c, p1d);
    assign p2y = lut_nand4(p2a, p2b, p2c, p2d);

endmodule