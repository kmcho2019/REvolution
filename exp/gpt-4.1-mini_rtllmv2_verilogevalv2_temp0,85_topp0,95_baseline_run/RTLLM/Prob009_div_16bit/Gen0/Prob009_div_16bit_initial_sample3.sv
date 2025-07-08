module div_16bit (
    input  wire [15:0] A,    // 16-bit dividend
    input  wire [7:0]  B,    // 8-bit divisor
    output reg  [15:0] result, // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0]  b_reg;

integer i;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    // Initialize quotient and remainder
    result = 16'b0;
    odd    = 16'b0;

    // We will simulate the division using the method described:
    // remainder register is initially zero
    // At each step, shift remainder left by 1 and bring down one bit of the dividend
    // Compare top bits of remainder with divisor, set quotient bit accordingly
    // Note: The description requires extracting highest bits of the dividend matching divisor width,
    // but we implement the standard shift-subtract approach adapted to the description.

    // We keep remainder in 16 bits, but only top 8 bits matter for comparison with divisor

    for (i=15; i>=0; i=i-1) begin
        // Shift remainder left by 1 and bring down current bit of dividend
        odd = {odd[14:0], a_reg[i]};
        // Extract top 8 bits of remainder for comparison
        if (odd[15:8] >= b_reg) begin
            odd[15:8] = odd[15:8] - b_reg;
            result[i] = 1'b1;
        end else begin
            result[i] = 1'b0;
        end
    end
end

endmodule