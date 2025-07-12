module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);

    // Function to compute min of two unsigned 8-bit inputs
    function [7:0] min2;
        input [7:0] x, y;
        begin
            min2 = (x < y) ? x : y;
        end
    endfunction

    always @(*) begin
        // Compute intermediate minimums in balanced pairs
        reg [7:0] ab_min;
        reg [7:0] cd_min;

        ab_min = min2(a, b);
        cd_min = min2(c, d);
        min = min2(ab_min, cd_min);
    end

endmodule