module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output result_is_zero
);

    wire [7:0] b_sel = do_sub ? ~b : b;
    wire [8:0] sum = a + b_sel + do_sub;
    
    always @(*) begin
        out = sum[7:0];
    end
    
    assign result_is_zero = ~(|out);

endmodule