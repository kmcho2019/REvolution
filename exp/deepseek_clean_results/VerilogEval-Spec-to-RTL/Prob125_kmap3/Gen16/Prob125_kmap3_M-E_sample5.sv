module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // LUT implementation of the Karnaugh map
    // Address bits: {a,b,c}
    wire [7:0] lut = 8'b01110111;
    
    assign out = lut[{a,b,c}];
endmodule