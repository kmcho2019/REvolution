module TopModule(
    input  [7:0] a,  // 8-bit 2's complement input number
    input  [7:0] b,  // 8-bit 2's complement input number
    output [7:0] s,  // 8-bit result of the addition
    output      overflow  // indicator of signed overflow
);

    reg [7:0] s_reg;  // Register for storing the sum
    reg       overflow_reg;  // Register for storing the overflow status

    // Perform the addition and detect signed overflow
    always @(a or b) begin
        s_reg = a + b;  // Calculate the sum
        overflow_reg = (a[7] == b[7] && a[7] != s_reg[7]);  // Detect overflow
    end

    // Assign the calculated values to the outputs
    assign s = s_reg;
    assign overflow = overflow_reg;

endmodule