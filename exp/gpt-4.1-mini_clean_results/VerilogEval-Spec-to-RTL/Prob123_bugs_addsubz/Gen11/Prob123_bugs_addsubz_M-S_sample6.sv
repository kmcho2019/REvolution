module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output reg  [7:0] out,
    output reg        result_is_zero
);
    wire [7:0] b_invert;
    wire [7:0] sum;
    wire       carry_in = do_sub;
    wire       c_out;

    assign b_invert = b ^ {8{do_sub}}; // conditionally invert b for subtraction

    // Simple 8-bit ripple carry addition
    assign {c_out, sum} = a + b_invert + carry_in;

    always @(*) begin
        out = sum;
        result_is_zero = (sum == 8'b0);
    end
endmodule