module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_cond_inv;
    wire [8:0] sum;

    assign b_cond_inv = b ^ {8{do_sub}};              // Conditionally invert B if do_sub=1
    assign sum = {1'b0, a} + {1'b0, b_cond_inv} + do_sub;  // Add a + (b_cond_inv) + carry_in=do_sub

    always @(*) begin
        out = sum[7:0];                              // Result lower 8 bits
        result_is_zero = ~|out;                       // Zero flag: reduction NOR of out bits
    end

endmodule