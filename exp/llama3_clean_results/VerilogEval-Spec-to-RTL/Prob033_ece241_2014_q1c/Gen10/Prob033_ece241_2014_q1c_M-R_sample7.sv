module TopModule(
    input  [7:0] a,  // 8-bit 2's complement input number
    input  [7:0] b,  // 8-bit 2's complement input number
    output [7:0] s,  // 8-bit result of the addition
    output      overflow  // indicator of signed overflow
);

    // Perform the addition and detect overflow within an always block
    always @(*) begin
        // Add the two input numbers
        s = a + b;
        
        // Detect signed overflow by checking the sign bits of the inputs and the result
        overflow = (a[7] == b[7] && a[7] != s[7]);
    end

endmodule