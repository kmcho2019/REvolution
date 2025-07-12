module TopModule(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);

always @(*) begin
    sum = a ^ b ^ cin; // Most efficient implementation for sum
    cout = (a & b) | (a & cin) | (b & cin); // Two levels of logic for carry-out
end

endmodule