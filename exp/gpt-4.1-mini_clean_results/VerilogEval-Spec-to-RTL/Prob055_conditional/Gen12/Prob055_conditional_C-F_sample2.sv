module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);
    reg [7:0] min_ab, min_cd;
    always @(*) begin
        // First level of comparisons
        min_ab = (a < b) ? a : b;
        min_cd = (c < d) ? c : d;
        // Second level: final minimum
        min = (min_ab < min_cd) ? min_ab : min_cd;
    end
endmodule