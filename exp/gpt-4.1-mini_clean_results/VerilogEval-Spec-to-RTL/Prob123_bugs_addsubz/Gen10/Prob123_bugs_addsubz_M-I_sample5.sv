module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_inverted;
    wire [7:0] b_muxed;
    wire [8:0] sum_with_carry; // 9-bit to accommodate carry out

    assign b_inverted = ~b;
    assign b_muxed = do_sub ? b_inverted : b;

    // Perform addition or subtraction using do_sub as carry-in
    assign sum_with_carry = {1'b0, a} + {1'b0, b_muxed} + do_sub;

    always @(*) begin
        out = sum_with_carry[7:0];
        result_is_zero = (out == 8'b0);
    end

endmodule