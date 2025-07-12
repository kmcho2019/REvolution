module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    // Refactored code using nested ternary operators
    assign min = (a < b) ? ((a < c) ? (a < d ? a : d) : ((c < d) ? c : d)) : ((b < c) ? (b < d ? b : d) : ((c < d) ? c : d));

    // Alternative refactored code using an 'always' block
    // always @(*) begin
    //     if (a <= b && a <= c && a <= d) begin
    //         min = a;
    //     end else if (b <= c && b <= d) begin
    //         min = b;
    //     end else if (c <= d) begin
    //         min = c;
    //     end else begin
    //         min = d;
    //     end
    // end

endmodule