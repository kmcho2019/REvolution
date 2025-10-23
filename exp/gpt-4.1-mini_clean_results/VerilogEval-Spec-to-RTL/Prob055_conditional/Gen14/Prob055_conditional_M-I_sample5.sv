module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);
    always @(*) begin
        // Compute min between a and b
        reg [7:0] min_ab;
        reg [7:0] min_cd;

        min_ab = (a < b) ? a : b;
        min_cd = (c < d) ? c : d;
        min    = (min_ab < min_cd) ? min_ab : min_cd;
    end
endmodule