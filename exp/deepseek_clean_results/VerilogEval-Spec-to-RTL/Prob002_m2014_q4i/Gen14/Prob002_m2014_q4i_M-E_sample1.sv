module TopModule (
    output wire out
);
    // Internal 1-bit LUT storage
    reg [0:0] lut [0:0];
    
    // Initialize LUT with constant 0
    initial begin
        lut[0] = 1'b0;
    end
    
    // Output the constant value
    assign out = lut[0];
endmodule