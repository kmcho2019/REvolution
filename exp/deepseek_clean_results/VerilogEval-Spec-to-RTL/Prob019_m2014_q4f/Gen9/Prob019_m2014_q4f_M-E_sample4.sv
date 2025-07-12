module TopModule (
    input in1,
    input in2,
    output out
);
    // LUT mask for function out = in1 & ~in2
    // Truth table: 00:0, 01:0, 10:1, 11:0
    parameter [3:0] LUT_MASK = 4'b0010;
    
    wire [1:0] lut_addr;
    
    assign lut_addr = {in1, in2};
    assign out = LUT_MASK[lut_addr];
endmodule