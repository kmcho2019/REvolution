module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] b_inv;
    assign b_inv = do_sub ? (~b + 1) : b;

    always @(*) begin
        out = a + b_inv;
        result_is_zero = ~(out[0] | out[1] | out[2] | out[3] | out[4] | out[5] | out[6] | out[7]);
    end

endmodule