module div_16bit (
    input  wire [15:0] A,      // Dividend
    input  wire [7:0]  B,      // Divisor
    output reg  [15:0] result, // Quotient
    output reg  [15:0] odd     // Remainder (lower 8 bits valid)
);

    reg [8:0] remainder;       // 9-bit remainder to hold intermediate values (8 bits divisor + 1)
    integer i;

    always @(*) begin
        remainder = 9'd0;
        result = 16'd0;
        for (i = 15; i >= 0; i = i -1) begin
            remainder = {remainder[7:0], A[i]};           // Shift left remainder, insert next dividend bit
            if (remainder >= {1'b0, B}) begin
                remainder = remainder - {1'b0, B};
                result[i] = 1'b1;
            end else begin
                result[i] = 1'b0;
            end
        end
        odd = {8'd0, remainder[7:0]}; // zero extend remainder to 16 bits
    end

endmodule