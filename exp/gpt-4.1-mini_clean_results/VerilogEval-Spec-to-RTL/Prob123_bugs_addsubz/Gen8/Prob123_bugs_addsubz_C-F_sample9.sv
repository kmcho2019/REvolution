module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_xor;
    wire [8:0] sum_full;

    // Conditional invert B bits based on do_sub signal
    assign b_xor = b ^ {8{do_sub}};

    // Perform addition or subtraction using carry-in = do_sub
    assign sum_full = a + b_xor + do_sub;

    always @(*) begin
        out = sum_full[7:0];
        result_is_zero = ~|sum_full[7:0]; // reduction NOR sets zero flag
    end

endmodule