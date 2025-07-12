module TopModule (
    input in,
    output out
);
    // 1-bit LUT implementation of NOT gate
    reg [0:1] lut;
    
    initial begin
        lut[0] = 1'b1;  // when in=0, out=1
        lut[1] = 1'b0;  // when in=1, out=0
    end
    
    assign out = lut[in];
endmodule