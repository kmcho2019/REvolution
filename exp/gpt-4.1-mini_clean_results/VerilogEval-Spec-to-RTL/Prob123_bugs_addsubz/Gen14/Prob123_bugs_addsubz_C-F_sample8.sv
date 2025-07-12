module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output reg  [7:0] out,
    output reg        result_is_zero
);

    wire [7:0] b_xor;
    wire [8:0] full_sum;

    // Conditional inversion of b to perform subtraction when do_sub=1
    assign b_xor = b ^ {8{do_sub}};

    // Perform addition with carry-in equal to do_sub (0 for add, 1 for subtract)
    assign full_sum = {1'b0, a} + {1'b0, b_xor} + do_sub;

    always @(*) begin
        out = full_sum[7:0];
        result_is_zero = ~|full_sum[7:0];  // Zero flag: reduction NOR on output
    end

endmodule