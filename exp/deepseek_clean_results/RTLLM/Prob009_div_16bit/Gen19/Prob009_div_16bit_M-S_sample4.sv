module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    reg [7:0] remainder;
    reg [15:0] quotient;
    integer i;

    always @(*) begin
        remainder = 8'b0;
        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[6:0], A[i]};  // Shift left and bring next bit
            quotient[i] = (remainder >= B);
            if (quotient[i])
                remainder = remainder - B;
        end
    end

    assign result = quotient;
    assign odd = {8'b0, remainder};

endmodule