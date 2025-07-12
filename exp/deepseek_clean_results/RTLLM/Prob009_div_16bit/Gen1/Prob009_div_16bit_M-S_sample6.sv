module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [7:0] odd
);

    always @(*) begin
        reg [15:0] dividend = A;
        reg [7:0] divisor = B;
        reg [15:0] quotient = 0;
        reg [8:0] remainder = 0;  // Needs 1 extra bit for comparison
        
        for (int i = 0; i < 16; i = i + 1) begin
            // Shift remainder and dividend left by 1
            remainder = {remainder[7:0], dividend[15]};
            dividend = {dividend[14:0], 1'b0};
            
            // Compare and subtract if possible
            if (remainder >= {1'b0, divisor}) begin
                remainder = remainder - divisor;
                quotient[15 - i] = 1'b1;
            end else begin
                quotient[15 - i] = 1'b0;
            end
        end
        
        result = quotient;
        odd = remainder[7:0];
    end

endmodule