module TopModule (
    input in1,
    input in2,
    output out
);
    // LUT implementation of NOR truth table
    reg [0:3] lut;
    
    initial begin
        // Initialize LUT with NOR truth table
        lut[0] = 1'b1;  // 00 -> 1
        lut[1] = 1'b0;  // 01 -> 0
        lut[2] = 1'b0;  // 10 -> 0
        lut[3] = 1'b0;  // 11 -> 0
    end
    
    // Use inputs as address to select output
    assign out = lut[{in1, in2}];
endmodule