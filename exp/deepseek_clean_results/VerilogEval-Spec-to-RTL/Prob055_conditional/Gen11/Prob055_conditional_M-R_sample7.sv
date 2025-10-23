module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

    reg [7:0] min_ab;
    reg [7:0] min_cd;

    always @(*) begin
        // Parallel comparisons: a vs b and c vs d
        min_ab = (a < b) ? a : b;
        min_cd = (c < d) ? c : d;
        
        // Final comparison of the two intermediate results
        min = (min_ab < min_cd) ? min_ab : min_cd;
    end

endmodule