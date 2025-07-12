module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    always_comb begin
        sum = a ^ b;
        cout = a & b;
    end

endmodule