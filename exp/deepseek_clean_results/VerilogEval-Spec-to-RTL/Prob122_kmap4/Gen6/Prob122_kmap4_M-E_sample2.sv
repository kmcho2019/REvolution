module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Create 2-bit selector from cd inputs
    wire [1:0] sel = {c, d};
    
    // Create the 4 patterns corresponding to ab inputs
    wire pattern00 = ~a ^ b;  // For cd=00: 0,1,0,1
    wire pattern01 = a ^ ~b;  // For cd=01: 1,0,1,0
    wire pattern11 = ~a ^ b;  // For cd=11: same as 00
    wire pattern10 = a ^ ~b;  // For cd=10: same as 01
    
    // 4:1 mux implementation
    assign out = (sel == 2'b00) ? pattern00 :
                 (sel == 2'b01) ? pattern01 :
                 (sel == 2'b11) ? pattern11 :
                 pattern10;
endmodule