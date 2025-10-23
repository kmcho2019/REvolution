module TopModule (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

always @(*) begin
    sum = a ^ b;    // Sum: XOR of inputs
    cout = a & b;   // Carry-out: AND of inputs
end

endmodule