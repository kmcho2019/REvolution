module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;
reg [3:0] shift_amount;

always @(*) begin
    quotient = 0;
    remainder = A;
    
    // Determine the maximum shift amount
    shift_amount = 0;
    for (reg [3:0] i = 7; i >= 0; i = i - 1) begin
        if ((B << i) <= remainder) begin
            shift_amount = i;
        end else begin
            if (shift_amount == 0) begin
                shift_amount = i + 1;
            end
        end
    end

    // Perform the division
    reg [15:0] temp_quotient;
    reg [15:0] temp_remainder;
    temp_quotient = 0;
    temp_remainder = A;
    for (reg [3:0] i = shift_amount; i >= 0; i = i - 1) begin
        if ((B << i) <= temp_remainder) begin
            temp_quotient = temp_quotient | (1 << i);
            temp_remainder = temp_remainder - (B << i);
        end
    end

    result = temp_quotient;
    odd = temp_remainder;
end

endmodule