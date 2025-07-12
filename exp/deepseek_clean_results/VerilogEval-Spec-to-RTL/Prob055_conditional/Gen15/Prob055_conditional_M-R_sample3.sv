module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // First find min between a and b, and between c and d in parallel
    wire [7:0] min_ab = (a < b) ? a : b;
    wire [7:0] min_cd = (c < d) ? c : d;
    
    // Then find min between the two intermediate results
    assign min = (min_ab < min_cd) ? min_ab : min_cd;

endmodule