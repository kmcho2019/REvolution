module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    // Combined implementation for better PPA
    assign out_or_bitwise = a | b;
    assign out_or_logical = |(a | b);  // More efficient than |a || |b
    assign out_not = {~b, ~a};         // Maintain efficient NOT organization
endmodule