module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);

    // Truth table mask for (in1 XNOR in2) XOR in3
    // Index is {in3, in2, in1}
    parameter [7:0] LUT_MASK = 8'b10010110;
    
    wire [2:0] sel = {in3, in2, in1};
    assign out = LUT_MASK[sel];

endmodule