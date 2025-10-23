module TopModule (
    input a,
    input b,
    output q
);
    // LUT implementation of AND gate
    // Index: 00 (a=0,b=0) -> 0
    //        01 (a=0,b=1) -> 0
    //        10 (a=1,b=0) -> 0
    //        11 (a=1,b=1) -> 1
    wire [1:0] addr = {a, b};
    reg [3:0] lut = 4'b0001;  // AND truth table
    
    assign q = lut[addr];
endmodule