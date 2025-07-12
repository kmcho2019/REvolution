module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);

    wire [7:0] min_ab;
    wire [7:0] min_cd;

    // Compute minimum of a and b
    always @* begin
        if (a < b)
            min_ab = a;
        else
            min_ab = b;
    end

    // Compute minimum of c and d
    always @* begin
        if (c < d)
            min_cd = c;
        else
            min_cd = d;
    end

    // Compute minimum of min_ab and min_cd
    always @* begin
        if (min_ab < min_cd)
            min = min_ab;
        else
            min = min_cd;
    end

endmodule