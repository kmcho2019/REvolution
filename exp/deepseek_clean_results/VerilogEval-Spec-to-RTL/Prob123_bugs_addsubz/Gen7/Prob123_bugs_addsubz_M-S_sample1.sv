module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output result_is_zero
);

    always @(*) begin
        out = a + (do_sub ? ~b : b) + do_sub;
    end
    
    assign result_is_zero = ~(|out);

endmodule