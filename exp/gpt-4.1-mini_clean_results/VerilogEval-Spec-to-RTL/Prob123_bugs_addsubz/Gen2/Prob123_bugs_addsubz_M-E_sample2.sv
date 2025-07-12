module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] b_xored = b ^ {8{do_sub}};  // b if do_sub=0; ~b if do_sub=1
    wire [8:0] sum = {1'b0, a} + {1'b0, b_xored} + do_sub;

    always @(*) begin
        out = sum[7:0];
        result_is_zero = (out == 8'b0);
    end

endmodule