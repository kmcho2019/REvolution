module TopModule (
    input x,
    input y,
    output z
);
    // Mux-based implementation of z = (x^y) & x
    // When x=0: output 0
    // When x=1: output ~y
    assign z = x ? ~y : 1'b0;
endmodule