module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Equivalent to: f = (~x3 & x2) | (x3 & x1)
    // Implemented efficiently as 2:1 mux:
    //   When x3=0: select x2 (f follows x2)
    //   When x3=1: select x1 (f follows x1)
    assign f = x3 ? x1 : x2;
endmodule