module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd  // Reduced to 8-bit since remainder can't exceed divisor width
);

    reg [7:0] temp;
    reg [15:0] quotient;
    integer i;

    always @(*) begin
        temp = 8'b0;
        for (i = 15; i >= 0; i = i - 1) begin
            temp = {temp[6:0], A[i]};  // Shift in next bit
            quotient[i] = (temp >= B);
            if (quotient[i])
                temp = temp - B;
        end
    end

    assign result = quotient;
    assign odd = temp;  // Final remainder is in temp

endmodule