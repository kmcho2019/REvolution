module TopModule(
    input a,
    input b,
    output out
);
    wire or_out;
    
    // First implement OR gate
    assign or_out = a | b;
    
    // Then invert the OR output
    assign out = ~or_out;
endmodule