module TopModule (
    output out
);
    // Constant inputs to LUT (won't change but demonstrate LUT concept)
    wire [1:0] lut_inputs = 2'b00;  // Could be any value, output will still be 0
    
    // 2-bit LUT implemented with assign and case expression
    assign out = (lut_inputs == 2'b00) ? 1'b0 :
                 (lut_inputs == 2'b01) ? 1'b0 :
                 (lut_inputs == 2'b10) ? 1'b0 :
                 1'b0;
endmodule