module TopModule(
    input  a,
    input  b,
    output reg sum,
    output reg cout
);

always_comb begin
    sum = a ^ b;
    cout = a & b;
end

endmodule