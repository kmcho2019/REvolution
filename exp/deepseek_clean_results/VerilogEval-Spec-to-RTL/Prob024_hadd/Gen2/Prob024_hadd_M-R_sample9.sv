module TopModule (
    input  a,
    input  b,
    output reg sum,
    output reg cout
);
    // Half adder implemented using always block
    always @(*) begin
        sum = a ^ b;   // XOR operation for sum
        cout = a & b;  // AND operation for carry-out
    end
endmodule