module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_mod;
    wire [8:0] sum;

    // Combinational logic: conditionally invert B and add with carry-in = do_sub
    assign b_mod = b ^ {8{do_sub}};
    assign sum = {1'b0, a} + {1'b0, b_mod} + do_sub;

    // Wire for zero detection
    wire zero_flag = ~|sum[7:0];

    // Register outputs on any input changes (combinational triggers)
    always @(*) begin
        out = sum[7:0];
        result_is_zero = zero_flag;
    end

endmodule