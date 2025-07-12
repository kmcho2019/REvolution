module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    wire [3:0] input_pattern = {a, b, c, d};

    // Sum-of-products via direct pattern matching
    assign out_sop = (input_pattern == 4'b0010) |  // 2
                     (input_pattern == 4'b0111) |  // 7
                     (input_pattern == 4'b1111);   // 15

    // Product-of-sums via inverse pattern blocking
    assign out_pos = ~((input_pattern == 4'b0000) |  // 0
                       (input_pattern == 4'b0001) |  // 1
                       (input_pattern == 4'b0100) |  // 4
                       (input_pattern == 4'b0101) |  // 5
                       (input_pattern == 4'b0110) |  // 6
                       (input_pattern == 4'b1001) |  // 9
                       (input_pattern == 4'b1010) |  // 10
                       (input_pattern == 4'b1101) |  // 13
                       (input_pattern == 4'b1110));  // 14

endmodule