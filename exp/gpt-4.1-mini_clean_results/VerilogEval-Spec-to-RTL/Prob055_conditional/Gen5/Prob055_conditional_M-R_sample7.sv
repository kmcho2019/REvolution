module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);

    always @* begin
        reg [7:0] min_ab;
        reg [7:0] min_tmp;

        // Compare a and b
        if (a < b)
            min_ab = a;
        else
            min_ab = b;

        // Compare c and d
        if (c < d)
            min_tmp = c;
        else
            min_tmp = d;

        // Compare intermediate mins to get final min
        if (min_ab < min_tmp)
            min = min_ab;
        else
            min = min_tmp;
    end

endmodule