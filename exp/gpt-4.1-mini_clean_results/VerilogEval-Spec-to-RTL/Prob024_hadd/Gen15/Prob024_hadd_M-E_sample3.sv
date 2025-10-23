module TopModule (
    input  a,
    input  b,
    output reg sum,
    output reg cout
);

always @(*) begin
    sum  = a ^ b;   // sum bit as XOR of inputs
    cout = a & b;   // carry-out bit as AND of inputs
end

endmodule