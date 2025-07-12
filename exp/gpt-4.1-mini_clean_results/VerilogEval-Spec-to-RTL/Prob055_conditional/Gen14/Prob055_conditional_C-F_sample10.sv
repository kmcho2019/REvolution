module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);

    // Inline function for 2-input minimum of 8-bit unsigned numbers
    function [7:0] min2;
        input [7:0] x, y;
        begin
            min2 = (x < y) ? x : y;
        end
    endfunction

    always @* begin
        // Balanced reduction tree:
        // stage 1: minimum of pairs
        // stage 2: minimum of stage 1 results
        reg [7:0] min_ab, min_cd;

        min_ab = min2(a, b);
        min_cd = min2(c, d);
        min = min2(min_ab, min_cd);
    end

endmodule