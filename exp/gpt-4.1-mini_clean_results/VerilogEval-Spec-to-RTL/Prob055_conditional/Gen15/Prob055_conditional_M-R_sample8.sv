module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    // Function to compute 2-input minimum
    function [7:0] min2;
        input [7:0] x, y;
        begin
            min2 = (x < y) ? x : y;
        end
    endfunction

    wire [7:0] min_ab = min2(a, b);
    wire [7:0] min_cd = min2(c, d);

    assign min = min2(min_ab, min_cd);

endmodule