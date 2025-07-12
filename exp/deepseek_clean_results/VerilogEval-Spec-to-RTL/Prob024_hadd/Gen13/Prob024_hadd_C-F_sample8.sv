module TopModule (
    input a,
    input b,
    output reg sum,
    output reg cout
);

    always @(*) begin
        // Explicit bitwise operations that clearly show the gate-level functionality
        sum = a ^ b;   // XOR operation for sum
        cout = a & b;  // AND operation for carry-out
    end

endmodule