module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_mux;
    wire [8:0] sum_ext;

    // Conditional inversion of b based on do_sub for two's complement subtraction
    assign b_mux = b ^ {8{do_sub}};
    // Add a + b_mux + do_sub (carry_in)
    assign sum_ext = {1'b0, a} + {1'b0, b_mux} + do_sub;

    always @(*) begin
        out = sum_ext[7:0];
        if (out == 8'b0)
            result_is_zero = 1'b1;
        else
            result_is_zero = 1'b0;
    end

endmodule