module TopModule (
    input in,
    output out
);
    // 1-bit LUT implementation of NOT gate
    reg [1:0] lut;
    
    initial begin
        // Initialize LUT with NOT gate truth table
        lut[0] = 1'b1;  // output when in=0
        lut[1] = 1'b0;   // output when in=1
    end
    
    assign out = lut[in];
endmodule