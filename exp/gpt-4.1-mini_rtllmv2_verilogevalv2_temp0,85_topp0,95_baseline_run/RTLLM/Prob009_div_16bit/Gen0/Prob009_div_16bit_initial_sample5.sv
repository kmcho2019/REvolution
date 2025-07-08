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
    // Using shift-subtract approach with quotient/result and remainder (odd)
    integer i;
    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [7:0]  top_bits;
    reg [8:0]  diff; // 9 bits to hold subtraction result

    always @(*) begin
        quotient = 16'b0;
        remainder = 16'b0;
        // Iterate over each bit from MSB to LSB
        // At each step:
        // 1) Concatenate remainder shifted left by 1 with current bit of a_reg
        // 2) Extract top 8 bits of remainder for comparison with b_reg
        // 3) If top bits >= b_reg, subtract and set quotient bit to 1
        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[14:0], a_reg[i]}; // shift left and bring in next bit
            top_bits = remainder[15:8];             // top 8 bits of remainder
            if (top_bits >= b_reg) begin
                diff = {1'b0, top_bits} - {1'b0, b_reg}; // 9-bit subtraction
                remainder[15:8] = diff[7:0];             // update top bits of remainder
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = remainder;
    end

endmodule