module TopModule(
    input  a,
    input  b,
    input  cin,
    output reg cout,
    output reg sum
);

    always @(*) begin
        // Calculate the sum using XOR operation
        sum = a ^ b ^ cin;

        // Calculate the carry-out using AND and OR operations
        cout = (a & b) | (a & cin) | (b & cin);
    end

endmodule