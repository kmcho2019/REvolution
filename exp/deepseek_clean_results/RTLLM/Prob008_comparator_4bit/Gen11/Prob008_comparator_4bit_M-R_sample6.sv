module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    // Internal state encoding
    localparam EQ = 2'b00;
    localparam GT = 2'b01;
    localparam LT = 2'b10;

    reg [1:0] cmp_state;

    always @(*) begin
        casez ({A, B})
            // Equal case (all bits match)
            {4'b????, 4'b????}: if (A == B) cmp_state = EQ;

            // Greater than cases (MSB difference first)
            {4'b1???, 4'b0???},
            {4'b?1??, 4'b?0??},
            {4'b??1?, 4'b??0?},
            {4'b???1, 4'b???0}: cmp_state = GT;

            // Less than (all other cases)
            default: cmp_state = LT;
        endcase

        // Output assignments - mutually exclusive by case structure
        A_equal  = (cmp_state == EQ);
        A_greater = (cmp_state == GT);
        A_less   = (cmp_state == LT);
    end

endmodule