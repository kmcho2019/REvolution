module min2(
    input  [7:0] x,
    input  [7:0] y,
    output [7:0] min_out
);
    assign min_out = (x < y) ? x : y;
endmodule

module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);
    // Intermediate variables for balanced comparisons
    reg [7:0] min_ab, min_cd;

    always @(*) begin
        // balanced comparisons in procedural style for minimal logic depth
        min_ab = (a < b) ? a : b;
        min_cd = (c < d) ? c : d;
        min = (min_ab < min_cd) ? min_ab : min_cd;
    end

endmodule