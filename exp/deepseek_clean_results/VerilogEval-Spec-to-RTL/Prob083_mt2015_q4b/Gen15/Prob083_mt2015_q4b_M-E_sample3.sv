module TopModule (
    input x,
    input y,
    output z
);
    // Implement XNOR using a small ROM/LUT
    // Address bits: {x,y}
    // Data: XNOR truth table
    reg [0:3] rom;
    
    initial begin
        rom[0] = 1'b1;  // 00 -> 1
        rom[1] = 1'b0;  // 01 -> 0
        rom[2] = 1'b0;  // 10 -> 0
        rom[3] = 1'b1;  // 11 -> 1
    end
    
    assign z = rom[{x,y}];
endmodule