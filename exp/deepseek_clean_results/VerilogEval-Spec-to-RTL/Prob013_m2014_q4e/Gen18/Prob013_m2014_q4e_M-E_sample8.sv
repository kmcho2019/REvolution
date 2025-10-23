module TopModule (
    input in1,
    input in2,
    output out
);
    // LUT-based NOR implementation
    reg [3:0] lut;
    
    // Initialize LUT with NOR truth table
    initial begin
        lut[0] = 1'b1;  // 00 -> 1
        lut[1] = 1'b0;  // 01 -> 0
        lut[2] = 1'b0;  // 10 -> 0
        lut[3] = 1'b0;  // 11 -> 0
    end
    
    // Select output based on input combination
    assign out = lut[{in1, in2}];
endmodule