module TopModule (
    input in1,
    input in2,
    output out
);
    // LUT implementation of NOR gate
    reg [0:3] nor_lut;
    
    initial begin
        // Initialize LUT with NOR truth table
        nor_lut[0] = 1'b1;  // 00 -> 1
        nor_lut[1] = 1'b0;  // 01 -> 0
        nor_lut[2] = 1'b0;  // 10 -> 0
        nor_lut[3] = 1'b0;  // 11 -> 0
    end
    
    // Use inputs as address to lookup the result
    assign out = nor_lut[{in1, in2}];
endmodule