module TopModule (
    input in,
    output out
);
    // NOT gate implemented using a 1-bit LUT approach
    wire [1:0] lut = 2'b10; // LUT[0] = 1, LUT[1] = 0 (NOT function)
    
    assign out = lut[in];
endmodule