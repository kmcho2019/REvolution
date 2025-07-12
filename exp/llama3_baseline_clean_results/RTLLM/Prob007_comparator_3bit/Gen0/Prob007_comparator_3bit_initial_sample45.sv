module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

assign A_greater = (A > B) ? 1'b1 : 1'b0;
assign A_equal = (A == B) ? 1'b1 : 1'b0;
assign A_less = (A < B) ? 1'b1 : 1'b0;

// Alternative implementation using if-else statements
// always @(*) begin
//     if (A > B) begin
//         A_greater = 1'b1;
//         A_equal = 1'b0;
//         A_less = 1'b0;
//     end else if (A == B) begin
//         A_greater = 1'b0;
//         A_equal = 1'b1;
//         A_less = 1'b0;
//     end else begin
//         A_greater = 1'b0;
//         A_equal = 1'b0;
//         A_less = 1'b1;
//     end
// end

endmodule