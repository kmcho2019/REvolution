/*
 * TopModule - NOR Gate implemented using LUT/ROM approach
 * 
 * Functionality:
 * Implements a NOR gate using a 4x1 ROM/LUT that explicitly encodes the truth table
 * 
 * Advantages:
 * - Makes truth table directly visible in hardware
 * - Potentially better mapping to FPGA LUT resources
 * - Demonstrates alternative implementation strategy
 * 
 * Truth Table:
 * Address {a,b} | Data out
 * ------------- | --------
 *      00      |    1
 *      01      |    0
 *      10      |    0
 *      11      |    0
 */
module TopModule (
    input  a,
    input  b,
    output out
);
    
    // 4x1 ROM implementing NOR truth table
    reg [0:3] rom;
    
    initial begin
        rom[0] = 1'b1;  // a=0, b=0
        rom[1] = 1'b0;  // a=0, b=1
        rom[2] = 1'b0;  // a=1, b=0
        rom[3] = 1'b0;  // a=1, b=1
    end
    
    // Use input combination as address
    assign out = rom[{a,b}];
    
endmodule