module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs into registers (combinational, as requested)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division logic using restoring division approach with explicit extraction and concatenation
    always @(*) begin
        integer i;
        reg [7:0] remainder_part;  // highest bits of remainder matching divisor width
        reg [15:0] quotient_tmp;
        reg [15:0] remainder_tmp;  // remainder width same as dividend for concatenation

        quotient_tmp = 16'd0;
        remainder_tmp = 16'd0;

        // Initialize remainder_tmp with zero
        // We will shift in bits from a_reg one by one from MSB to LSB
        for (i = 15; i >= 0; i = i -1) begin
            // Shift left remainder by 1 and bring down next bit from a_reg
            remainder_tmp = {remainder_tmp[14:0], a_reg[i]};
            
            // Extract the top bits matching divisor width
            remainder_part = remainder_tmp[15 -:8];  // bits [15:8]
            
            // Compare and subtract if possible
            if (remainder_part >= b_reg) begin
                remainder_part = remainder_part - b_reg;
                quotient_tmp[i] = 1'b1;
            end else begin
                quotient_tmp[i] = 1'b0;
            end
            
            // Update remainder_tmp[15:8] with subtraction result
            remainder_tmp[15 -:8] = remainder_part;
        end

        result = quotient_tmp;
        odd = remainder_tmp;  // remainder after all bits processed
    end

endmodule