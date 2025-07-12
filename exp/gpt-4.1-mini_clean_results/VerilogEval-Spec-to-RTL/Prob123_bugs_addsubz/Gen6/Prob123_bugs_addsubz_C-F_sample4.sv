module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_inverted;
    wire [8:0] sum_ext;

    // Conditionally invert b for subtraction
    assign b_inverted = b ^ {8{do_sub}};

    // Perform addition with carry_in = do_sub for two's complement subtraction
    assign sum_ext = {1'b0, a} + {1'b0, b_inverted} + do_sub;

    // Register output and zero flag in a single always block for glitch reduction and timing stability
    always @(*) begin
        out = sum_ext[7:0];
        result_is_zero = ~|out;  // Reduction NOR to detect zero
    end

endmodule