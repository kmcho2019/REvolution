module TopModule(
    input  in,
    output out
);
    
    // Use an XOR gate with one input fixed to 0 to mimic a wire
    assign out = in ^ 1'b0;

endmodule