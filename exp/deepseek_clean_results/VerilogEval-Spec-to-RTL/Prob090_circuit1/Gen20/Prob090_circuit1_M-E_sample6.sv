module TopModule (
    input  a,
    input  b,
    output q
);
    // Implement AND using a 4-bit ROM (LUT)
    reg [3:0] rom;
    initial begin
        rom = 4'b0001; // AND truth table: 00->0, 01->0, 10->0, 11->1
    end
    
    assign q = rom[{b, a}];
endmodule