module TopModule (
    input in,
    output out
);
    // Implement NOT gate using a 1-bit LUT
    reg [1:0] lut;
    
    initial begin
        // Program the LUT for NOT function:
        // lut[0] = ~0 = 1
        // lut[1] = ~1 = 0
        lut[0] = 1'b1;
        lut[1] = 1'b0;
    end
    
    assign out = lut[in];
endmodule