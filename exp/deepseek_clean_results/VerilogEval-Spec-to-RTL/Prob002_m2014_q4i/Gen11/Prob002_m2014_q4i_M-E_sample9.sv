module TopModule (
    output out
);
    // 2-bit LUT that always outputs 0
    reg [1:0] lut [0:1];
    initial begin
        lut[0] = 1'b0;
        lut[1] = 1'b0;
    end
    
    // Use a dummy input (could be tied to ground for power optimization)
    wire dummy_input;
    assign dummy_input = 1'b0;  // Power-optimized version would tie this to GND
    
    // Output comes from LUT
    assign out = lut[dummy_input];
endmodule