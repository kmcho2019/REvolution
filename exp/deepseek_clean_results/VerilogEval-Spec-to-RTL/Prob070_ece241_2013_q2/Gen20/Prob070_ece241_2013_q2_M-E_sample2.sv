module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    wire [3:0] input_bus = {a, b, c, d};

    // Sum-of-products implementation using direct truth table
    assign out_sop = (input_bus == 4'b0010) ? 1'b1 :  // 2
                    (input_bus == 4'b0111) ? 1'b1 :   // 7
                    (input_bus == 4'b1111) ? 1'b1 :   // 15
                    (input_bus == 4'b0000) ? 1'b0 :   // 0
                    (input_bus == 4'b0001) ? 1'b0 :   // 1
                    (input_bus == 4'b0100) ? 1'b0 :   // 4
                    (input_bus == 4'b0101) ? 1'b0 :   // 5
                    (input_bus == 4'b0110) ? 1'b0 :   // 6
                    (input_bus == 4'b1001) ? 1'b0 :   // 9
                    (input_bus == 4'b1010) ? 1'b0 :   // 10
                    (input_bus == 4'b1101) ? 1'b0 :   // 13
                    (input_bus == 4'b1110) ? 1'b0 :   // 14
                    1'bx;                             // don't cares

    // Product-of-sums implementation using inverted truth table
    assign out_pos = (input_bus == 4'b0010) ? 1'b1 :  // 2
                    (input_bus == 4'b0111) ? 1'b1 :   // 7
                    (input_bus == 4'b1111) ? 1'b1 :   // 15
                    (input_bus == 4'b0000) ? 1'b0 :   // 0
                    (input_bus == 4'b0001) ? 1'b0 :   // 1
                    (input_bus == 4'b0100) ? 1'b0 :   // 4
                    (input_bus == 4'b0101) ? 1'b0 :   // 5
                    (input_bus == 4'b0110) ? 1'b0 :   // 6
                    (input_bus == 4'b1001) ? 1'b0 :   // 9
                    (input_bus == 4'b1010) ? 1'b0 :   // 10
                    (input_bus == 4'b1101) ? 1'b0 :   // 13
                    (input_bus == 4'b1110) ? 1'b0 :   // 14
                    1'bx;                             // don't cares

endmodule