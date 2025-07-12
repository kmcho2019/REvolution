module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;

always @(*) begin
    quotient = 0;
    remainder = A;
    
    // Determine the maximum shift amount
    reg [3:0] shift_amount;
    for (int i = 7; i >= 0; i--) begin
        if ((B << i) <= remainder) begin
            shift_amount = i;
            break;
        end
    end

    // Perform the division
    for (int i = shift_amount; i >= 0; i--) begin
        if ((B << i) <= remainder) begin
            quotient = quotient | (1 << i);
            remainder = remainder - (B << i);
        end
    end

    result = quotient;
    odd = remainder;
end

endmodule