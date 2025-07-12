module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    // Truth table implementation using a multiplexer
    // The output is selected based on the 3-bit input combination
    assign out = (in3) ? 
                ((in2) ? 
                    ((in1) ? 1'b0 : 1'b1) :  // in3=1, in2=1
                    ((in1) ? 1'b1 : 1'b0)) :  // in3=1, in2=0
                ((in2) ? 
                    ((in1) ? 1'b1 : 1'b0) :  // in3=0, in2=1
                    ((in1) ? 1'b0 : 1'b1));  // in3=0, in2=0
endmodule