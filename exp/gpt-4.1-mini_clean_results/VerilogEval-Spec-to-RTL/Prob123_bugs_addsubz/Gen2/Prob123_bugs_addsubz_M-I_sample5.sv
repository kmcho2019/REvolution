module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    always @(*) begin
        // Conditional inversion of b and carry-in handled in expression
        out = a + (b ^ {8{do_sub}}) + do_sub;
        result_is_zero = ~|out; // reduction NOR to detect zero
    end

endmodule