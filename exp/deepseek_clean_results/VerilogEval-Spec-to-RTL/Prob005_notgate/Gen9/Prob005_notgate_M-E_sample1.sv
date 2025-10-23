module TopModule (
    input in,
    output out
);
    // Implement NOT gate using a 1-bit LUT
    // LUT[0] = 1 (output when input is 0)
    // LUT[1] = 0 (output when input is 1)
    reg [1:0] lut = 2'b10;
    
    assign out = lut[in];
endmodule