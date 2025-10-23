module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output wire [15:0] result,  // Quotient
    output wire [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Division function: returns {quotient[15:0], remainder[8:0]}
    function [24:0] divide;
        input [15:0] dividend;
        input [7:0] divisor;
        integer i;
        reg [8:0] remainder;
        reg [15:0] quotient;
    begin
        remainder = 9'd0;
        quotient = 16'd0;
        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[7:0], dividend[i]};
            if (remainder >= {1'b0, divisor}) begin
                remainder = remainder - {1'b0, divisor};
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end
        divide = {quotient, remainder};
    end
    endfunction

    wire [24:0] div_res = divide(A, B);

    assign result = div_res[24:9];
    assign odd    = {8'd0, div_res[8:0]}; // zero-extend remainder to 16 bits

endmodule