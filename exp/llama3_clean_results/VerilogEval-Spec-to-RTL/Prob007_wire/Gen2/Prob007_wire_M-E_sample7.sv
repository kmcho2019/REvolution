module TopModule(
    input  in,
    output out
);
    
    // Using a buffer to isolate input from output
    bufif1 buf(out, in, 1'b1);

endmodule