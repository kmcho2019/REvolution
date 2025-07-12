module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] b_comp;
    wire [8:0] sum_ext;

    // Two's complement of b if do_sub=1, else b unchanged
    assign b_comp = do_sub ? (~b) : b;

    // Sum with carry_in equal to do_sub for addition or subtraction
    assign sum_ext = {1'b0, a} + {1'b0, b_comp} + do_sub;

    always @(*) begin
        out <= sum_ext[7:0];
        result_is_zero <= (sum_ext[7:0] == 8'b0);
    end

endmodule