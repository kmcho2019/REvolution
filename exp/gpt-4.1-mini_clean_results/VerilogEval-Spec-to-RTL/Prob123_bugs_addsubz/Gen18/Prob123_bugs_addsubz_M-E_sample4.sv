module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_mod;
    wire [8:0] sum; // 9-bit for carry out

    // If do_sub is 1, invert b for two's complement subtraction, else pass b unchanged
    assign b_mod = b ^ {8{do_sub}};

    // Perform addition with carry_in as do_sub, which adds the +1 in two's complement subtraction
    assign sum = {1'b0, a} + {1'b0, b_mod} + do_sub;

    always @(*) begin
        out = sum[7:0];
        result_is_zero = (out == 8'b0);
    end

endmodule