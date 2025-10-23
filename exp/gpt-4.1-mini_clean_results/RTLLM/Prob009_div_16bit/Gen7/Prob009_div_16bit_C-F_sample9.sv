module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (lower 8 bits valid)
);

    // First always block: combinational input register stage
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: combinational division logic
    always @(*) begin
        integer i;
        reg [8:0] remainder;     // 9-bit remainder (8-bit divisor + 1 bit for borrow)
        reg [15:0] quotient;
        reg [8:0] divisor_ext;

        remainder = 9'd0;
        quotient = 16'd0;
        divisor_ext = {1'b0, b_reg}; // zero-extend divisor to 9 bits

        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[7:0], a_reg[i]};
            if (remainder >= divisor_ext) begin
                remainder = remainder - divisor_ext;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'd0, remainder[7:0]};
    end

endmodule