module TopModule (
    input a,
    input b,
    output q
);
    // AND gate implemented using a 2:1 mux
    assign q = a ? b : 1'b0;
endmodule