module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire mux_sum;
    wire mux_cout;
    
    // First mux selects between a and b based on cin
    assign mux_sum = cin ? a : b;
    
    // Second mux selects between OR and AND based on cin
    assign mux_cout = cin ? (a | b) : (a & b);
    
    // Final sum is XOR of mux output with the other input
    assign sum = mux_sum ^ (cin ? b : a);
    
    // Carry out is the mux output
    assign cout = mux_cout;
endmodule