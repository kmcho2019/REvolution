module TopModule (
    input x,
    input y,
    output z
);
    // LUT implementation of z = (x^y) & x
    reg [0:3] lut;
    
    initial begin
        // Precompute all possible outputs
        lut[0] = 1'b0; // x=0, y=0
        lut[1] = 1'b0; // x=0, y=1
        lut[2] = 1'b1; // x=1, y=0
        lut[3] = 1'b0; // x=1, y=1
    end
    
    assign z = lut[{x,y}];
endmodule