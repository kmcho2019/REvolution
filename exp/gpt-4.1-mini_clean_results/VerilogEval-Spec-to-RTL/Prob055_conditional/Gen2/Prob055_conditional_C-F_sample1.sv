module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);

    wire [7:0] min_ab = (a < b) ? a : b;
    wire [7:0] min_cd = (c < d) ? c : d;

    always @(*) begin
        if (min_ab < min_cd)
            min = min_ab;
        else
            min = min_cd;
    end

endmodule