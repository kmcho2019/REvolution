module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_xor;
    wire [8:0] sum_ext;

    // Conditional invert B based on do_sub to implement subtraction as addition with two's complement
    assign b_xor = b ^ {8{do_sub}};
    
    // sum_ext computes a + b_xor + do_sub (do_sub acts as carry-in)
    assign sum_ext = {1'b0, a} + {1'b0, b_xor} + do_sub;

    always @(*) begin
        out = sum_ext[7:0];
        result_is_zero = ~|out;
    end

endmodule