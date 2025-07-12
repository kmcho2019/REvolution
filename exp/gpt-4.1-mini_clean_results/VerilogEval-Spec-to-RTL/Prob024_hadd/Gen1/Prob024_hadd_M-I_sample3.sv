module TopModule(
    input  a,
    input  b,
    output reg sum,
    output reg cout
);
    always @(*) begin
        sum = a ^ b;    // XOR for sum
        cout = a & b;   // AND for carry-out
    end
endmodule