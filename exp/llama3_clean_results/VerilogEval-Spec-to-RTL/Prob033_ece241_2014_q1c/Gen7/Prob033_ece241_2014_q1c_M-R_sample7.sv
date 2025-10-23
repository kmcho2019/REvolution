module TopModule(
    input  [7:0] a,  // 8-bit 2's complement input number
    input  [7:0] b,  // 8-bit 2's complement input number
    output [7:0] s,  // 8-bit result of the addition
    output      overflow  // indicator of signed overflow
);

    reg [7:0] s_reg;  // Internal register for the sum
    reg      overflow_reg;  // Internal register for overflow flag

    always @(*) begin
        // Directly add the two numbers
        s_reg = a + b;
        
        // Detect overflow by comparing the most significant bits
        overflow_reg = (a[7] == b[7]) && (a[7] != s_reg[7]);
    end

    // Continuous assignments to outputs
    assign s = s_reg;
    assign overflow = overflow_reg;

endmodule