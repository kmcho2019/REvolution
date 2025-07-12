module TopModule (
    input wire a,
    input wire b,
    output reg sum,
    output reg cout
);

always @(*) begin
    sum = a ^ b;
    cout = a & b;
end

endmodule