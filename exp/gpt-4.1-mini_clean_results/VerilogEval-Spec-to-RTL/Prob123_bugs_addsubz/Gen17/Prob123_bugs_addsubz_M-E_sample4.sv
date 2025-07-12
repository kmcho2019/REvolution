module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire signed [8:0] b_signed;    // Extend to 9 bits for sign and negation
    wire signed [8:0] a_signed;    // Extend to 9 bits for addition
    wire signed [8:0] sum_signed;

    always @(*) begin
        a_signed = {1'b0, a};                               // Zero-extend a to 9 bits
        b_signed = do_sub ? -{1'b0, b} : {1'b0, b};        // Conditionally negate b

        sum_signed = a_signed + b_signed;                   // Perform add or subtract

        out = sum_signed[7:0];                              // Truncate to 8 bits (ignore carry-out)
        result_is_zero = ~|out;                             // Zero flag by reduction NOR
    end

endmodule