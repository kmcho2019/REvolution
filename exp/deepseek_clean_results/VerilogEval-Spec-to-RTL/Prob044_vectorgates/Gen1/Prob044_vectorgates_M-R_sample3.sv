module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // All OR operations grouped together
    assign out_or_bitwise = a | b;
    assign out_or_logical = |(a | b);  // More efficient single reduction OR

    // All NOT operations grouped together
    assign out_not = {~b, ~a};  // Concatenation for cleaner bit placement

endmodule