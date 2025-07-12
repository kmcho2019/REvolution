module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    reg [7:0] min_ab;
    reg [7:0] min_cd;
    reg [7:0] min_temp;

    always @(a or b or c or d) begin
        // Find the minimum of a and b
        min_ab = (a < b)? a : b;
        
        // Find the minimum of c and d
        min_cd = (c < d)? c : d;
        
        // Find the minimum of min_ab and min_cd
        min = (min_ab < min_cd)? min_ab : min_cd;
    end

endmodule