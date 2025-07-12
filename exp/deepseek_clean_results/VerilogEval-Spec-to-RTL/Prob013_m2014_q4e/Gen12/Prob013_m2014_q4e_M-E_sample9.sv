module TopModule (
    input in1,
    input in2,
    output out
);
    // LUT implementation of NOR gate
    parameter [3:0] NOR_LUT = 4'b1000; // Truth table for NOR
    
    assign out = NOR_LUT[{in1, in2}];
endmodule