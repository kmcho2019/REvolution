module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output result_is_zero
);

    wire [7:0] b_in = do_sub ? ~b : b;
    wire cin = do_sub;
    
    // Lower 4-bit adder
    wire [3:0] sum_lo = a[3:0] + b_in[3:0] + cin;
    wire carry_lo = (a[3:0] + b_in[3:0] + cin) >> 4;
    
    // Upper 4-bit adders (both carry scenarios)
    wire [3:0] sum_hi_c0 = a[7:4] + b_in[7:4];
    wire [3:0] sum_hi_c1 = a[7:4] + b_in[7:4] + 1;
    
    // Result muxing
    wire [3:0] sum_hi = carry_lo ? sum_hi_c1 : sum_hi_c0;
    
    // Early zero detection
    wire zero_lo = ~(|sum_lo);
    wire zero_hi_c0 = ~(|sum_hi_c0);
    wire zero_hi_c1 = ~(|sum_hi_c1);
    wire zero_hi = carry_lo ? zero_hi_c1 : zero_hi_c0;
    
    always @(*) begin
        out = {sum_hi, sum_lo};
    end
    
    assign result_is_zero = zero_lo & zero_hi;

endmodule