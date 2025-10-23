module TopModule(
    input  a,
    input  b,
    output reg sum,
    output reg cout
);

    always @(*) begin
        sum = a ^ b; // XOR operation to calculate the sum
        cout = a & b; // AND operation to calculate the carry-out
    end

endmodule