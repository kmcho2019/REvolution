module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs into registers
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic
    always @(*) begin
        reg [15:0] quotient;
        reg [15:0] remainder; // Will hold partial remainder, up to 16 bits
        reg [7:0]  divisor;
        integer i;

        quotient = 16'b0;
        remainder = 16'b0;
        divisor = b_reg;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next bit from dividend
            remainder = {remainder[14:0], a_reg[i]};

            // Compare higher bits of remainder (width equal to divisor width)
            if (remainder[15:8] >= divisor) begin
                // Set quotient bit
                quotient[i] = 1'b1;
                // Subtract divisor from higher bits of remainder
                remainder[15:8] = remainder[15:8] - divisor;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = remainder;
    end

endmodule