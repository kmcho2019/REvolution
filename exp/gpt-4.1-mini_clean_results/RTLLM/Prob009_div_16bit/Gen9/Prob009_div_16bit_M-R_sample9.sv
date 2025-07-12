module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (lower 8 bits valid)
);

    // Input registers replaced by continuous assignments for cleaner logic
    wire [15:0] a_reg = A;
    wire [7:0]  b_reg = B;

    // Function implementing the division logic combinationally
    function [24:0] div_func; // {quotient[15:0], remainder[8:0]}
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
        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[7:0], dividend[i]};
            if (remainder >= divisor_ext) begin
                remainder = remainder - divisor_ext;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end
        div_func = {quotient, remainder};
    end
    endfunction

    // Second always block: combinational division logic using the function
    always @(*) begin
        reg [24:0] div_result;
        div_result = div_func(a_reg, b_reg);
        result = div_result[24:9];            // quotient[15:0]
        odd    = {8'd0, div_result[8:0][7:0]}; // remainder zero-extended to 16 bits (take lower 8 bits)
    end

endmodule