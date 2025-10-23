module TopModule (
    input  in1,
    input  in2,
    output out
);
    // 2-input NOR gate implemented as 4-bit LUT
    wire [3:0] nor_lut = 4'b1000; // Truth table: 00->1, 01->0, 10->0, 11->0
    
    assign out = nor_lut[{in1, in2}];
endmodule