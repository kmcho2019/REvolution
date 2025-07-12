module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // 16-bit LUT storing the Karnaugh map pattern
    wire [15:0] lut = 16'b0101101001011010;
    
    // Use inputs as 4-bit address (d,c,b,a)
    assign out = lut[{d,c,b,a}];
endmodule