module TopModule(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);
    always @(*) begin
        // Sum calculation (XOR of all inputs)
        sum = a ^ b ^ cin;
        
        // Carry-out calculation (majority function)
        cout = (a & b) | (a & cin) | (b & cin);
    end
endmodule