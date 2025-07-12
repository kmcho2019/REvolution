module TopModule(input in, output out);
    // Implement as a 1-input LUT (lookup table)
    reg lut [0:1];
    
    initial begin
        lut[0] = 0;  // Output when input is 0
        lut[1] = 1;  // Output when input is 1
    end
    
    assign out = lut[in];
endmodule