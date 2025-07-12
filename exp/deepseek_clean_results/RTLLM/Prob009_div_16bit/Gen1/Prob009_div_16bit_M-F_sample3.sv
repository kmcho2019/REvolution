module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [7:0] odd
);

    always @(*) begin
        reg [15:0] quotient = 0;
        reg [8:0] remainder = 0;  // One extra bit for comparison
        integer i;

        // Handle division by zero case
        if (B == 8'b0) begin
            result = 16'hFFFF;
            odd = 8'hFF;
        end else begin
            remainder = 0;
            for (i = 0; i < 16; i = i + 1) begin
                remainder = {remainder[7:0], A[15 - i]};
                
                if (remainder >= {1'b0, B}) begin
                    remainder = remainder - B;
                    quotient[15 - i] = 1'b1;
                end else begin
                    quotient[15 - i] = 1'b0;
                end
            end
            result = quotient;
            odd = remainder[7:0];
        end
    end

endmodule