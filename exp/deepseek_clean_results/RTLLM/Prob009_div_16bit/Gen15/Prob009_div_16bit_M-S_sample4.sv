module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [8:0] remainder;
    integer i;

    always @(*) begin
        remainder = 9'b0;
        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[7:0], A[i]};  // Shift left and bring in next bit
            
            if (remainder >= B) begin
                result[i] = 1'b1;
                remainder = remainder - B;
            end else begin
                result[i] = 1'b0;
            end
        end
        odd = {8'b0, remainder[7:0]};  // Remainder is only 8 bits
    end

endmodule