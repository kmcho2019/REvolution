module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);

    always @(*) begin
        // Find minimum of a and b
        wire [7:0] ab_min = (a < b) ? a : b;
        // Find minimum of c and d
        wire [7:0] cd_min = (c < d) ? c : d;
        // Final minimum
        min = (ab_min < cd_min) ? ab_min : cd_min;
    end

endmodule