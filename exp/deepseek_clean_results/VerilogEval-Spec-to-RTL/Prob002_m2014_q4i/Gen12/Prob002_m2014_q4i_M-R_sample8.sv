module TopModule (
    output out
);
    // Constant inputs to LUT (could be any value since output is always 0)
    wire [1:0] lut_inputs = 2'b00;
    
    // 2-bit LUT programmed to always output 0
    assign out = (lut_inputs == 2'b00) ? 1'b0 :
                 (lut_inputs == 2'b01) ? 1'b0 :
                 (lut_inputs == 2'b10) ? 1'b0 :
                 1'b0;
endmodule