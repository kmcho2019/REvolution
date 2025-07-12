module TopModule(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);
    always @(a or b or cin) begin
        sum = a ^ b ^ cin;
        cout = (a & b) | ((a ^ b) & cin);
    end
endmodule