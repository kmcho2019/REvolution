module TopModule(
    input  in1,
    input  in2,
    output out
);
    // Using a multiplexer to implement the NOR gate
    // When in1 and in2 are both 0, out should be 1
    // In all other cases, out should be 0
    assign out = (in1 == 0 && in2 == 0) ? 1'b1 : 1'b0;
    
    // Alternative implementation using a MUX
    // assign out = in1 ? (in2 ? 1'b0 : 1'b0) : (in2 ? 1'b0 : 1'b1);
endmodule