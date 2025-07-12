module TopModule #(parameter WIDTH = 8) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [WIDTH-1:0] c,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] min
);

    wire [WIDTH-1:0] min_ab = (a < b) ? a : b;
    wire [WIDTH-1:0] min_cd = (c < d) ? c : d;
    
    assign min = (min_ab < min_cd) ? min_ab : min_cd;

endmodule