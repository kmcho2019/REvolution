module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] b_comp; // two's complement of b
    assign b_comp = do_sub ? (~b + 1) : b;

    always @(*) begin
        out = a + b_comp;
        result_is_zero = ~(|out); // set flag if out is zero
    end

endmodule