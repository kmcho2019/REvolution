module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    reg [7:0] ab_min;
    reg [7:0] cd_min;

    always @(a, b, c, d) begin
        // Find the minimum of a and b
        ab_min = (a < b) ? a : b;
        
        // Find the minimum of c and d
        cd_min = (c < d) ? c : d;
        
        // Find the minimum of ab_min and cd_min
        min = (ab_min < cd_min) ? ab_min : cd_min;
    end

endmodule