module TopModule (
    input p1a, p1b, p1c, p1d,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    // Function to implement 4-input NAND using truth table approach
    function automatic nand4;
        input a, b, c, d;
        reg [15:0] lut = 16'b1111111111111110; // Truth table for 4-input NAND
        begin
            nand4 = lut[{a,b,c,d}];
        end
    endfunction

    // First 4-input NAND gate
    assign p1y = nand4(p1a, p1b, p1c, p1d);

    // Second 4-input NAND gate
    assign p2y = nand4(p2a, p2b, p2c, p2d);

endmodule