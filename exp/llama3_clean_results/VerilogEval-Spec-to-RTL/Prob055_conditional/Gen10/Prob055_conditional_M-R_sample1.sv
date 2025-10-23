module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

assign min = (a < b && a < c && a < d) ? a :
             (b < a && b < c && b < d) ? b :
             (c < a && c < b && c < d) ? c : d;

// Alternatively, you can use the following expression which is a bit more concise
// assign min = (a < b) ? ((a < c && a < d) ? a : (c < d) ? c : d) :
//                 ((b < c && b < d) ? b : (c < d) ? c : d);

endmodule