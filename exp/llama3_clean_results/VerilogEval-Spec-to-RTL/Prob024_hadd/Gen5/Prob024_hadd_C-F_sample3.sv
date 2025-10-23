module TopModule(
    input  a,
    input  b,
    output reg sum,
    output reg cout
);
    
    always @(*) begin
        // Directly calculate sum and carry-out using XOR and AND operators
        sum = a ^ b;
        cout = a & b;
    end

endmodule