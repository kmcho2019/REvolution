module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output reg  [7:0] out,
    output reg        result_is_zero
);

    reg [7:0] b_inverted;
    reg [8:0] sum_with_cin;

    always @(*) begin
        // Invert b if do_sub is high, else keep b unchanged
        b_inverted = b ^ {8{do_sub}};

        // Add a + b_inverted + do_sub (carry-in)
        sum_with_cin = {1'b0, a} + {1'b0, b_inverted} + do_sub;

        // Assign lower 8 bits to output
        out = sum_with_cin[7:0];

        // result_is_zero is set if output is zero
        result_is_zero = ~|out;
    end

endmodule