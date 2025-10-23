module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    reg [7:0] min_ab;
    reg [7:0] min_cd;

    always @(*) begin
        // Find minimum of a and b
        if (a < b) begin
            min_ab = a;
        end else begin
            min_ab = b;
        end

        // Find minimum of c and d
        if (c < d) begin
            min_cd = c;
        end else begin
            min_cd = d;
        end

        // Find minimum of min_ab and min_cd
        if (min_ab < min_cd) begin
            min = min_ab;
        end else begin
            min = min_cd;
        end
    end

endmodule