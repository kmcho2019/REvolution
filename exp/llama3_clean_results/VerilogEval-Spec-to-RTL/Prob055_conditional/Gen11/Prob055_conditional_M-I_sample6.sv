module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Compare pairs of inputs and select the smaller value, then compare the results
    assign min = (a < b)? ((a < c)? ((a < d)? a : d) : ((c < d)? c : d)) : 
                 ((b < c)? ((b < d)? b : d) : ((c < d)? c : d));

endmodule