module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);

    always @(*) begin
        sum = a ^ b;
        cout = a & b;
    end

endmodule