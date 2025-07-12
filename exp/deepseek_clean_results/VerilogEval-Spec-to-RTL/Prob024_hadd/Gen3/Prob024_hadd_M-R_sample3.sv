module TopModule(
    input a,
    input b,
    output reg sum,
    output reg cout
);
    always @(a or b) begin
        sum = a ^ b;   // XOR operation for sum
        cout = a & b;  // AND operation for carry-out
    end
endmodule