module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output reg  [7:0] out,
    output reg        result_is_zero
);

    wire [7:0] sum;
    wire       zero_flag;

    // Use conditional operator to select addition or subtraction
    assign sum = do_sub ? (a - b) : (a + b);

    // Zero flag is asserted if sum is zero
    assign zero_flag = ~|sum; // Reduction NOR

    // Update output registers combinationally
    always @(*) begin
        out = sum;
        result_is_zero = zero_flag;
    end

endmodule