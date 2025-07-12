module TopModule(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);
    always @(*) begin
        // Optimal sum calculation (XOR chain)
        sum = a ^ b ^ cin;
        
        // More efficient carry-out calculation
        cout = (a & b) | ((a ^ b) & cin);
    end
endmodule