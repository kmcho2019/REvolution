module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    reg [15:0] quotient;
    reg [7:0] remainder;
    integer i;

    always @(*) begin
        remainder = 8'b0;
        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[6:0], A[i]};  // Shift left and bring in next bit
            quotient[i] = (remainder >= B);
            if (quotient[i])
                remainder = remainder - B;
        end
    end

    assign result = quotient;
    assign odd = remainder;

endmodule