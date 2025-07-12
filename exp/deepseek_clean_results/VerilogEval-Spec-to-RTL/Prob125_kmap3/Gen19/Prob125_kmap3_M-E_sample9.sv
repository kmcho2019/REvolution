module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // LUT-style implementation with 16-bit mask
    // Index order: {a,b,c,d}
    // Don't-care cases filled with 1 for simpler mask
    wire [15:0] lut_mask = 16'b0111_0011_1111_0000;
    
    assign out = lut_mask[{a,b,c,d}];
endmodule