module TopModule(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);
    always @* begin
        // Sum is the XOR of all three inputs
        sum = a ^ b ^ cin;
        
        // Carry-out is 1 when at least two inputs are 1
        cout = (a & b) | (a & cin) | (b & cin);
    end
endmodule