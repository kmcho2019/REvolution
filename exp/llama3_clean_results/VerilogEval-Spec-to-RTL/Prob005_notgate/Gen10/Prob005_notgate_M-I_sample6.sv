module TopModule(
    input  in,
    output out
);
    // Directly assign the inverse of the input to the output
    // This is the most straightforward and efficient way to implement a NOT gate in Verilog
    assign out = ~in;
endmodule