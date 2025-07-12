module TopModule (
    input a,
    input b,
    output out
);
    // LUT-based XNOR implementation
    reg [3:0] lut;
    
    initial begin
        lut[0] = 1'b1;  // a=0, b=0
        lut[1] = 1'b0;  // a=0, b=1
        lut[2] = 1'b0;  // a=1, b=0
        lut[3] = 1'b1;  // a=1, b=1
    end
    
    assign out = lut[{a, b}];
endmodule