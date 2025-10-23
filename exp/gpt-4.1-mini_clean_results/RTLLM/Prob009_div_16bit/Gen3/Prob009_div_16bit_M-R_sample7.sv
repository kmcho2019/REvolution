module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    // Combinational division logic in one always block
    always @(*) begin
        reg [15:0] quotient;
        reg [7:0] remainder;
        integer i;

        // Default outputs
        quotient = 16'd0;
        remainder = 8'd0;

        if (B == 8'd0) begin
            // Division by zero: define outputs as zero (could be altered as needed)
            quotient = 16'd0;
            remainder = 8'd0;
        end else begin
            // Division algorithm
            for (i = 15; i >= 0; i = i - 1) begin
                // Shift left remainder by 1, bring in next bit of dividend
                remainder = {remainder[6:0], A[i]};

                // Compare remainder and divisor
                if (remainder >= B) begin
                    remainder = remainder - B;
                    quotient[i] = 1'b1;
                end else begin
                    quotient[i] = 1'b0;
                end
            end
        end

        result = quotient;
        odd = {8'b0, remainder}; // remainder zero-extended to 16 bits
    end

endmodule