module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

reg q_temp;

always @(*) begin
    q_temp = a ^ b ^ c ^ d;
    q = ~q_temp;
end

assign q = ~q_temp;

// Alternatively, without using assign and directly using a reg for output
// module TopModule(
//     input  a,
//     input  b,
//     input  c,
//     input  d,
//     output reg q
// );

// always @(*) begin
//     q = ~(a ^ b ^ c ^ d);
// end

endmodule