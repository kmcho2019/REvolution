module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output [15:0] result,
    output [15:0] odd
);

    // Function performing 16-bit by 8-bit division, returning quotient and remainder
    function automatic [31:0] divide_16by8;
        input [15:0] dividend;
        input [7:0] divisor;
        integer i;
        reg [8:0] remainder;       // 9-bit remainder to hold comparison and subtraction
        reg [15:0] quotient;
        reg [8:0] divisor_ext;

        begin
            remainder = 9'b0;
            quotient = 16'b0;
            divisor_ext = {1'b0, divisor};

            for (i = 15; i >= 0; i = i - 1) begin
                remainder = {remainder[7:0], dividend[i]};
                if (remainder >= divisor_ext) begin
                    remainder = remainder - divisor_ext;
                    quotient[i] = 1'b1;
                end else begin
                    quotient[i] = 1'b0;
                end
            end

            // Pack quotient and remainder into a 32-bit value:
            // [31:16] = quotient, [15:0] = remainder zero-extended to 16 bits
            divide_16by8 = {quotient, {8'b0, remainder[7:0]}};
        end
    endfunction

    wire [31:0] div_out;

    assign div_out = divide_16by8(A, B);

    assign result = div_out[31:16];
    assign odd    = div_out[15:0];

endmodule