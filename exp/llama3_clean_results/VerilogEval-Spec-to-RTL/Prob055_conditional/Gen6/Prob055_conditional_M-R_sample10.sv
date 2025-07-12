module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    reg [7:0] min_ab, min_cd, min_reg;

    always @(*) begin
        // Compare a and b, and c and d, and assign the smaller value to min_ab and min_cd respectively
        min_ab = (a < b) ? a : b;
        min_cd = (c < d) ? c : d;

        // Finally, compare min_ab and min_cd to determine the overall minimum
        min_reg = (min_ab < min_cd) ? min_ab : min_cd;
    end

    assign min = min_reg;

endmodule