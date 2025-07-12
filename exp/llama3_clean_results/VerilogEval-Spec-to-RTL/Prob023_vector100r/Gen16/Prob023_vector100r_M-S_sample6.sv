module TopModule(
    input [99:0] in,
    output reg [99:0] out
);

always @(*) begin
    out = in;
end

// To reverse the bits, use the following line instead:
// out = {in[99], in[98], in[97],..., in[1], in[0]};
// However, this is verbose for 100 bits. The following line achieves the same:
// Assign each bit individually without a loop
// out = in[99]? 1 : 0;
// out[1] = in[98]? 1 : 0;
//...
// out[99] = in[0]? 1 : 0;
// A simpler approach for bit reversal in Verilog:
assign out = {<<{in}};

endmodule