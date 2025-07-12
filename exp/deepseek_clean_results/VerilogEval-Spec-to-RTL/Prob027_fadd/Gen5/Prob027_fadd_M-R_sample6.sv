module TopModule(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);
    always @(*) begin
        // Sum is XOR of all inputs
        sum = a ^ b ^ cin;
        
        // Carry-out is majority function
        cout = (a & b) | (a & cin) | (b & cin);
    end
endmodule