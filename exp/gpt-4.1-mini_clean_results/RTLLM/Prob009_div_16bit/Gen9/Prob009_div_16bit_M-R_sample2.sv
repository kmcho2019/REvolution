module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (lower 8 bits valid)
);

    // Input registers updated by continuous assignments (first always block replaced)
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Using continuous assignments instead of always block for input registration
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division function performing combinational division iteratively
    function automatic [24:0] divide_16_by_8;
        input [15:0] dividend;
        input [7:0]  divisor;
        integer i;
        reg [8:0] remainder;
        reg [15:0] quotient;
        reg [8:0] divisor_ext;
        begin
            remainder = 9'd0;
            quotient = 16'd0;
            divisor_ext = {1'b0, divisor};
            for (i = 15; i >= 0; i = i -1) begin
                remainder = {remainder[7:0], dividend[i]};
                if (remainder >= divisor_ext) begin
                    remainder = remainder - divisor_ext;
                    quotient[i] = 1'b1;
                end else begin
                    quotient[i] = 1'b0;
                end
            end
            // Return concatenated quotient and remainder (16+9 bits)
            divide_16_by_8 = {quotient, remainder};
        end
    endfunction

    // Combinational block (second always block) using the division function
    always @(*) begin
        reg [24:0] div_out;
        div_out = divide_16_by_8(a_reg, b_reg);
        result = div_out[24:9];      // 16-bit quotient
        odd = {8'd0, div_out[8:1]};  // 8-bit remainder zero-extended to 16-bit output
    end

endmodule