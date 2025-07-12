module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);

    reg [7:0] min_ab, min_cd;

    always @(*) begin
        // Compare a and b
        if (a < b)
            min_ab = a;
        else
            min_ab = b;

        // Compare c and d
        if (c < d)
            min_cd = c;
        else
            min_cd = d;

        // Compare min_ab and min_cd
        if (min_ab < min_cd)
            min = min_ab;
        else
            min = min_cd;
    end

endmodule