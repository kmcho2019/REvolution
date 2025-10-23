module min2(
    input  [7:0] x,
    input  [7:0] y,
    output [7:0] z
);
    assign z = (x < y) ? x : y;
endmodule

module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    // Define a function implementing min2 logic internally for reuse in continuous assignments
    function [7:0] min2_func;
        input [7:0] x;
        input [7:0] y;
        begin
            min2_func = (x < y) ? x : y;
        end
    endfunction

    // Compute min(a,b) and min(c,d) using the internal function and continuous assignments
    wire [7:0] min_ab = min2_func(a, b);
    wire [7:0] min_cd = min2_func(c, d);

    // Compute the final min as continuous assignment using the internal function
    assign min = min2_func(min_ab, min_cd);

endmodule