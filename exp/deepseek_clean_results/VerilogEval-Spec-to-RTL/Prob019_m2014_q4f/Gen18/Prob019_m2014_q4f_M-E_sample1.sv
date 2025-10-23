module TopModule (
    input in1,
    input in2,
    output out
);
    // LUT mask for the function out = in1 & ~in2
    // Indexed as {in1,in2}: 00->0, 01->0, 10->1, 11->0
    wire [3:0] lut_mask = 4'b0010;
    
    // Use inputs as index into LUT
    assign out = lut_mask[{in1, in2}];
endmodule