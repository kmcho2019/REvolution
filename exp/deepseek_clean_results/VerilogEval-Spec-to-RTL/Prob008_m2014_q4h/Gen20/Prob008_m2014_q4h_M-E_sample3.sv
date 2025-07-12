module TopModule (
    input  in,
    output out
);
    // 1-bit LUT implementation of identity function
    reg [1:0] lut;  // 2-entry LUT (1-bit address space)
    
    // Initialize LUT with identity function
    initial begin
        lut[0] = 1'b0;
        lut[1] = 1'b1;
    end
    
    // Use input as LUT address
    assign out = lut[in];
endmodule