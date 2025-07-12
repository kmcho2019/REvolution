module TopModule(
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] s,
    output reg overflow
);
    wire carry_in, carry_out;
    
    always @(*) begin
        {carry_out, s} = a + b;
        carry_in = a[7] ^ b[7] ^ s[7];  // Carry into MSB
        overflow = carry_out ^ carry_in; // Overflow occurs when carry in ≠ carry out
    end
endmodule