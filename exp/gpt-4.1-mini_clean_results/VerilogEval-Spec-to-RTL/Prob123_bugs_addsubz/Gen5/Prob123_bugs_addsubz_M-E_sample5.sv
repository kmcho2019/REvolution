module TopModule (
    input        do_sub,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out,
    output       result_is_zero
);

    wire [7:0] b_mod;
    wire [8:0] sum_ext;

    // Compute two's complement of b if do_sub=1 for subtraction
    assign b_mod = b ^ {8{do_sub}};       // bitwise invert b if do_sub=1
    assign sum_ext = {1'b0, a} + {1'b0, b_mod} + do_sub;

    assign out = sum_ext[7:0];
    assign result_is_zero = ~|sum_ext[7:0];  // reduction NOR to detect zero result

endmodule