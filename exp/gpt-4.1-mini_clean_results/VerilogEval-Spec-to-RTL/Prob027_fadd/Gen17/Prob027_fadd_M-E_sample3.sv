module TopModule (
    input  a,
    input  b,
    input  cin,
    output reg cout,
    output reg sum
);
    always @(*) begin
        // Sum is XOR of all inputs
        sum = a ^ b ^ cin;
        // Carry-out is majority function of the three inputs
        cout = (a & b) | (b & cin) | (a & cin);
    end
endmodule