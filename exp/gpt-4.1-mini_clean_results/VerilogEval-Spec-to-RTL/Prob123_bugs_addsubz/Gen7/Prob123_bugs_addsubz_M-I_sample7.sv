module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output result_is_zero
);

    wire [7:0] b_inverted;
    wire [7:0] sum;
    wire carry_in;

    assign b_inverted = b ^ {8{do_sub}};   // invert b if do_sub=1 for subtraction
    assign carry_in = do_sub;              // carry_in = 1 for subtraction (+1 in two's complement)
    assign sum = a + b_inverted + carry_in;

    always @(*) begin
        out = sum;
    end

    assign result_is_zero = ~|out;         // zero flag combinationally from output

endmodule