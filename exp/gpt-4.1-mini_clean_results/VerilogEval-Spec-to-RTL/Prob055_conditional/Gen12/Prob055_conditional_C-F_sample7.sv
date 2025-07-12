module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);

    // Function to find min of two 8-bit unsigned values
    function [7:0] min2;
        input [7:0] x, y;
        begin
            min2 = (x < y) ? x : y;
        end
    endfunction

    always @* begin
        // Compute pairwise minimums in parallel
        reg [7:0] min_ab, min_cd;
        min_ab = min2(a, b);
        min_cd = min2(c, d);

        // Final minimum of the two intermediate minimums
        min = min2(min_ab, min_cd);
    end

endmodule