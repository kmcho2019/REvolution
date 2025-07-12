module TopModule #(parameter WIDTH = 8) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [WIDTH-1:0] c,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] min
);
    // Single expression finds minimum of four values
    assign min = ((a < b ? a : b) < (c < d ? c : d)) ? 
                 (a < b ? a : b) : 
                 (c < d ? c : d);
endmodule