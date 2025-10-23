module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output reg  [7:0] out,
    output reg        result_is_zero
);

    wire [7:0] b_inverted;
    wire [7:0] sum;
    wire       carry_in;

    assign b_inverted = b ^ {8{do_sub}};  // Conditional inversion of b for subtraction
    assign carry_in = do_sub;             // Carry-in is 1 for subtraction (two's complement add)

    assign sum = a + b_inverted + carry_in;

    always @(*) begin
        out = sum;
        result_is_zero = ~|out;           // Zero flag from registered output
    end

endmodule