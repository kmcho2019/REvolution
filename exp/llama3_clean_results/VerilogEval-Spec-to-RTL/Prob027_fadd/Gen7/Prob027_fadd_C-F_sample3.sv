module TopModule(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);

always @(*) begin
    reg ha1_sum;
    reg ha1_cout;
    reg ha2_sum;
    reg ha2_cout;

    ha1_sum = a ^ b;
    ha1_cout = a & b;

    ha2_sum = ha1_sum ^ cin;
    ha2_cout = (ha1_sum & cin) | ha1_cout;

    sum = ha2_sum;
    cout = ha2_cout;
end

endmodule