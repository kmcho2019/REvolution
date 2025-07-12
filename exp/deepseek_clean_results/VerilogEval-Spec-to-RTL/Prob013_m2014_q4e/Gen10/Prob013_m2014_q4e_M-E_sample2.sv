module TopModule (
    input in1,
    input in2,
    output out
);
    wire or_out;
    
    // First implement the OR operation
    or(or_out, in1, in2);
    
    // Then invert the result
    not(out, or_out);
endmodule