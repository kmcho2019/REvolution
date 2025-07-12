module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [15:0] low, high, mid;
    reg [15:0] product;
    integer i;

    always @(*) begin
        if (B == 8'b0) begin
            // Handle division by zero case
            quotient = 16'hFFFF;
            remainder = 16'hFFFF;
        end else begin
            // Initialize binary search bounds
            low = 16'b0;
            high = {8'b0, 8'hFF}; // Max possible quotient (255)
            quotient = 16'b0;

            // Binary search for quotient
            for (i = 0; i < 8; i = i + 1) begin
                mid = (low + high) >> 1;
                product = mid * {8'b0, B};

                if (product == A) begin
                    quotient = mid;
                    break;
                end else if (product < A) begin
                    low = mid + 1;
                    quotient = mid; // Current best candidate
                end else begin
                    high = mid - 1;
                end
            end

            // Calculate final remainder
            remainder = A - (quotient * {8'b0, B});
        end

        result = quotient;
        odd = remainder;
    end

endmodule