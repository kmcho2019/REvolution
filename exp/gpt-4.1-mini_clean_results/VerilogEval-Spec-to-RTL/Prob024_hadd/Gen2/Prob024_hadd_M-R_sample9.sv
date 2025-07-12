module TopModule (
    input  a,       // Input bit a
    input  b,       // Input bit b
    output reg sum, // Sum output: XOR of a and b
    output reg cout // Carry out: AND of a and b
);
    always @(*) begin
        sum  = a ^ b;  // Sum is XOR of inputs
        cout = a & b;  // Carry-out is AND of inputs
    end
endmodule