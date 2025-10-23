module TopModule (
    input a,
    input b,
    output out
);
    // 4-bit ROM storing XNOR truth table
    reg [0:3] rom;
    
    // Initialize ROM with XNOR truth table
    initial begin
        rom[0] = 1'b1;  // 00 -> 1
        rom[1] = 1'b0;  // 01 -> 0
        rom[2] = 1'b0;  // 10 -> 0
        rom[3] = 1'b1;  // 11 -> 1
    end
    
    // Use inputs as address to lookup the output
    assign out = rom[{a, b}];
endmodule