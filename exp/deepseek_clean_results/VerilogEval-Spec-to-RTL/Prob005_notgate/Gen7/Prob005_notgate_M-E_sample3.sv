module TopModule (
    input in,
    output out
);
    // Implement NOT gate using a 1-bit LUT
    reg [1:0] lut;
    
    initial begin
        lut[0] = 1'b1;  // Output when input is 0
        lut[1] = 1'b0;  // Output when input is 1
    end
    
    assign out = lut[in];
endmodule