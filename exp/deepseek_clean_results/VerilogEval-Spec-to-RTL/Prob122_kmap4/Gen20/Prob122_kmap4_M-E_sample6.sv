module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    /* ROM-based implementation that directly encodes the K-map:
       The 4 inputs form a 4-bit address to index into the ROM
       ROM contents follow the exact pattern specified in the K-map
    */
    
    reg [15:0] rom;
    
    initial begin
        // Initialize ROM according to K-map pattern
        // Address bits: {a,b,c,d}
        rom[4'b0000] = 0;  // a=0,b=0,c=0,d=0
        rom[4'b0001] = 1;  // a=0,b=0,c=0,d=1
        rom[4'b0010] = 0;  // a=0,b=0,c=1,d=0
        rom[4'b0011] = 1;  // a=0,b=0,c=1,d=1
        rom[4'b0100] = 1;  // a=0,b=1,c=0,d=0
        rom[4'b0101] = 0;  // a=0,b=1,c=0,d=1
        rom[4'b0110] = 1;  // a=0,b=1,c=1,d=0
        rom[4'b0111] = 0;  // a=0,b=1,c=1,d=1
        rom[4'b1000] = 1;  // a=1,b=0,c=0,d=0
        rom[4'b1001] = 0;  // a=1,b=0,c=0,d=1
        rom[4'b1010] = 1;  // a=1,b=0,c=1,d=0
        rom[4'b1011] = 0;  // a=1,b=0,c=1,d=1
        rom[4'b1100] = 0;  // a=1,b=1,c=0,d=0
        rom[4'b1101] = 1;  // a=1,b=1,c=0,d=1
        rom[4'b1110] = 0;  // a=1,b=1,c=1,d=0
        rom[4'b1111] = 1;  // a=1,b=1,c=1,d=1
    end
    
    assign out = rom[{a,b,c,d}];

endmodule