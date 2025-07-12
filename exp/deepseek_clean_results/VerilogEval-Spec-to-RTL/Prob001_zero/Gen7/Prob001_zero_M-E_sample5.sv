module TopModule (
    output zero
);
    // 1-bit wide, 1-entry deep ROM that always outputs 0
    reg [0:0] rom [0:0];
    initial begin
        rom[0] = 1'b0;  // Initialize ROM with constant 0
    end
    
    // Output the ROM value (address doesn't matter)
    assign zero = rom[0];
    
    // Note: This demonstrates how constants can be stored in memory structures
    // though it's not efficient for this simple case
endmodule