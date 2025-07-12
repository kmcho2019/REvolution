module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);
    reg [7:0] ab_min;
    reg [7:0] cd_min;

    always @* begin
        if (a < b)
            ab_min = a;
        else
            ab_min = b;

        if (c < d)
            cd_min = c;
        else
            cd_min = d;

        if (ab_min < cd_min)
            min = ab_min;
        else
            min = cd_min;
    end
endmodule