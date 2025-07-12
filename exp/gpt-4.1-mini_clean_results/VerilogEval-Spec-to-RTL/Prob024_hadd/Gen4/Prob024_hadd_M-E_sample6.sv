module TopModule (
    input  a,
    input  b,
    output reg sum,
    output reg cout
);

always @(*) begin
    sum = (a & ~b) | (~a & b);  // XOR implemented with AND and OR gates behaviorally
    cout = a & b;
end

endmodule