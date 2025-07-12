module TopModule (
    input a,
    input b,
    output q
);
    // Implement AND using a MUX structure
    assign q = a ? b : 1'b0;
endmodule