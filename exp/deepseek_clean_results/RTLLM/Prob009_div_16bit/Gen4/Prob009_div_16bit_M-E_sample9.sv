module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    // Pre-compute divisor multiples
    wire [11:0] B_x1 = {4'b0, B};
    wire [11:0] B_x2 = {3'b0, B, 1'b0};
    wire [11:0] B_x4 = {2'b0, B, 2'b0};
    wire [11:0] B_x8 = {1'b0, B, 3'b0};

    reg [11:0] current_remainder;
    reg [15:0] quotient;
    integer i;

    always @(*) begin
        current_remainder = 12'b0;
        quotient = 16'b0;

        // Process 4-bit chunks (nibbles)
        for (i = 3; i >= 0; i = i - 1) begin
            // Bring down next 4 bits
            current_remainder = {current_remainder[7:0], A[i*4 +: 4]};
            
            // Hierarchical comparison
            if (current_remainder >= B_x8) begin
                current_remainder = current_remainder - B_x8;
                quotient[i*4 + 3] = 1'b1;
            end else if (current_remainder >= B_x4) begin
                current_remainder = current_remainder - B_x4;
                quotient[i*4 + 2] = 1'b1;
            end else if (current_remainder >= B_x2) begin
                current_remainder = current_remainder - B_x2;
                quotient[i*4 + 1] = 1'b1;
            end else if (current_remainder >= B_x1) begin
                current_remainder = current_remainder - B_x1;
                quotient[i*4] = 1'b1;
            end
            
            // Shift quotient left by 4 bits
            if (i != 0) begin
                quotient = quotient << 4;
            end
        end

        result = quotient;
        odd = {8'b0, current_remainder[7:0]}; // Only need 8-bit remainder
    end

endmodule