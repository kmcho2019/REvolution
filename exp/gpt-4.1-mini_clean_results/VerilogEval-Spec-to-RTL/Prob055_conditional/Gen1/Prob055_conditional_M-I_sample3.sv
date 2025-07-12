module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    // Function to find minimum of two 8-bit unsigned numbers
    function [7:0] min2;
        input [7:0] x, y;
        begin
            min2 = (x < y) ? x : y;
        end
    endfunction

    wire [7:0] ab_min = min2(a, b);
    wire [7:0] cd_min = min2(c, d);

    assign min = min2(ab_min, cd_min);

endmodule