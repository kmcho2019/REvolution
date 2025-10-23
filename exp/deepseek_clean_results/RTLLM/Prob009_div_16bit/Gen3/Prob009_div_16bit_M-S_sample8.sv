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
        quotient = 16'b0;
        
        if (B == 8'b0) begin
            // Division by zero case
            quotient = 16'hFFFF;
            remainder = A[7:0]; // Only need lower 8 bits
        end else begin
            // Normal division
            for (i = 15; i >= 0; i = i - 1) begin
                remainder = {remainder[6:0], A[i]}; // Shift left and append next bit
                
                if (remainder >= B) begin
                    remainder = remainder - B;
                    quotient[i] = 1'b1;
                end
            end
        end
    end

    assign result = quotient;
    assign odd = remainder;

endmodule