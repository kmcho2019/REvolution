module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_mod;
    wire [8:0] sum_ext;

    // Conditional inversion of b for subtraction
    assign b_mod = b ^ {8{do_sub}};

    // Perform addition with carry_in = do_sub to implement subtraction correctly
    assign sum_ext = {1'b0, a} + {1'b0, b_mod} + do_sub;

    always @(*) begin
        out = sum_ext[7:0];
        result_is_zero = ~|sum_ext[7:0]; // reduction NOR for zero flag
    end

endmodule