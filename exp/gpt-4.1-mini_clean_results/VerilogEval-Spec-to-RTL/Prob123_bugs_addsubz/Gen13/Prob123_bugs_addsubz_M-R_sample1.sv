module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_inverted;
    wire [7:0] sum;

    // Conditionally invert b for subtraction (two's complement)
    assign b_inverted = b ^ {8{do_sub}};
    // Add a + b_inverted + do_sub (do_sub acts as carry_in for subtraction)
    assign sum = a + b_inverted + do_sub;

    always @(*) begin
        out = sum;
        result_is_zero = ~|sum;  // Reduction NOR: 1 if sum is zero, else 0
    end

endmodule