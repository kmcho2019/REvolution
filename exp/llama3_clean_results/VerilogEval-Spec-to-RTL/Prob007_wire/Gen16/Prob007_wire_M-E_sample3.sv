module TopModule(
    input  in,
    output out
);
    
    // Use an XOR gate to implement the wire functionality
    // The XOR gate's output will be the same as the input 'in' when the other input is tied to 0
    assign out = in ^ 1'b0;

endmodule