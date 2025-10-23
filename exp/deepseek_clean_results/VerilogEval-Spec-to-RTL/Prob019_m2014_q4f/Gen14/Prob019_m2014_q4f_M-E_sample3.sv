module TopModule (
    input in1,
    input in2,
    output out
);
    // LUT implementation of in1 AND NOT in2
    reg [0:3] lut;
    
    initial begin
        lut[0] = 1'b0; // 00
        lut[1] = 1'b1; // 01
        lut[2] = 1'b0; // 10
        lut[3] = 1'b0; // 11
    end
    
    assign out = lut[{in1, in2}];
endmodule