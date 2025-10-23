module TopModule(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);

reg ab, ac, bc;

always @(*) begin
    ab = a & b;
    ac = a & cin;
    bc = b & cin;
    
    cout = ab | ac | bc;
    sum = a ^ b ^ cin;
end

endmodule