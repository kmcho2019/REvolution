module TopModule (
    input in1,
    input in2,
    output out
);
    // Core NOR functionality remains optimal
    wire nor_out;
    assign nor_out = ~(in1 | in2);
    
    // Optional output buffer for drive strength
    bufif1 (out, nor_out, 1'b1);  // Always enabled buffer
    
    // Alternative implementation using primitive NOR gate
    // nor (out, in1, in2);
endmodule