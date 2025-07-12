module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    // Internal state encoding
    localparam EQ = 2'b01;
    localparam GT = 2'b10;
    localparam LT = 2'b00;

    reg [1:0] cmp_state;

    always @(*) begin
        casez ({A, B})
            // Equal case
            {4'b0000, 4'b0000},
            {4'b0001, 4'b0001},
            {4'b0010, 4'b0010},
            {4'b0011, 4'b0011},
            {4'b0100, 4'b0100},
            {4'b0101, 4'b0101},
            {4'b0110, 4'b0110},
            {4'b0111, 4'b0111},
            {4'b1000, 4'b1000},
            {4'b1001, 4'b1001},
            {4'b1010, 4'b1010},
            {4'b1011, 4'b1011},
            {4'b1100, 4'b1100},
            {4'b1101, 4'b1101},
            {4'b1110, 4'b1110},
            {4'b1111, 4'b1111}: cmp_state = EQ;

            // Greater than cases (priority encoded)
            {4'b1???, 4'b0???},
            {4'b?1??, 4'b?0??},
            {4'b??1?, 4'b??0?},
            {4'b???1, 4'b???0}: cmp_state = GT;

            // Default to less than
            default: cmp_state = LT;
        endcase

        // Output assignments
        A_equal = (cmp_state == EQ);
        A_greater = (cmp_state == GT);
        A_less = (cmp_state == LT);
    end

endmodule