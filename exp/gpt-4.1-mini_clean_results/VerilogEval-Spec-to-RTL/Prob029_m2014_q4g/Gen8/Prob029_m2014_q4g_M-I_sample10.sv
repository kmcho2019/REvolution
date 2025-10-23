module TopModule (
    input  wire in1,
    input  wire in2,
    input  wire in3,
    output wire out
);

    wire xnor_intermediate;
    
    assign xnor_intermediate = ~(in1 ^ in2);
    assign out = xnor_intermediate ^ in3;

endmodule