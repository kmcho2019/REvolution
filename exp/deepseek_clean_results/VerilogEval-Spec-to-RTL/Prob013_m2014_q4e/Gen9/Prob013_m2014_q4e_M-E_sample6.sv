module TopModule (
    input  in1,
    input  in2,
    output out
);
    // 2-input NOR gate implemented as 4-bit LUT
    reg [3:0] nor_lut;
    
    initial begin
        nor_lut[0] = 1'b1;  // 00
        nor_lut[1] = 1'b0;  // 01
        nor_lut[2] = 1'b0;  // 10
        nor_lut[3] = 1'b0;  // 11
    end
    
    assign out = nor_lut[{in1, in2}];
endmodule