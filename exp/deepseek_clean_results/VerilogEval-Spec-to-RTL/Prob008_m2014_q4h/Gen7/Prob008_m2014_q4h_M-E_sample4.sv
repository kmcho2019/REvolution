module TopModule(input in, output out);
    // 1-bit LUT implementation (hardwired to pass-through)
    reg lut[0:1];
    
    initial begin
        lut[0] = 0;  // Output when in=0
        lut[1] = 1;  // Output when in=1
    end
    
    assign out = lut[in];
endmodule