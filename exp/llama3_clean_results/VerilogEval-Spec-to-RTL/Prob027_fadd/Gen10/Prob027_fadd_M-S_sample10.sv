module TopModule(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);

always @(*) begin
    sum = a ^ b ^ cin;  // Calculate sum using XOR of all inputs
    cout = (a & b) | (a & cin) | (b & cin);  // Calculate carry-out
end

endmodule