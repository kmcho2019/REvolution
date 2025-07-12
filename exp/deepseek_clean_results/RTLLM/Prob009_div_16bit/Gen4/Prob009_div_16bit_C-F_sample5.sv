module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] remainder;
    reg [15:0] quotient;
    integer i;
    wire [15:0] divisor_ext = {8'b0, B};  // Pre-compute once

    always @(*) begin
        remainder = 16'b0;
        quotient = 16'b0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left and bring next dividend bit
            remainder = {remainder[14:0], A[i]};

            // Compare and subtract if possible
            if (remainder >= divisor_ext) begin
                remainder = remainder - divisor_ext;
                quotient[i] = 1'b1;
            end
            // else quotient bit remains 0 (default)
        end

        result = quotient;
        odd = remainder;  // Full 16-bit remainder as per requirements
    end

endmodule