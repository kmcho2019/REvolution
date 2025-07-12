module TopModule (
    input  a,
    input  b,
    input  cin,
    output reg cout,
    output reg sum
);
    always @(*) begin
        sum = a ^ b ^ cin;
        cout = (a & b) | (b & cin) | (a & cin);
    end
endmodule