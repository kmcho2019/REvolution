module TopModule(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);

always @(*) begin
    // Calculate sum and carry-out for the first half-adder (a and b)
    wire ha1_sum = a ^ b;
    wire ha1_cout = a & b;

    // Calculate sum and carry-out for the second half-adder (ha1_sum and cin)
    sum = ha1_sum ^ cin;
    cout = ha1_cout | (ha1_sum & cin);
end

endmodule