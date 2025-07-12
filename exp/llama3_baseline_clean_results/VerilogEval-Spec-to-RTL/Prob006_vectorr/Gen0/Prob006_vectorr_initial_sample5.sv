module TopModule(
    input  [7:0] in,
    output [7:0] out
);

assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

// Alternatively, a more concise way to achieve the same result:
// assign out = in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7];
// But the above line does not work in Verilog. Instead, we can use the following:
// assign out = in[7:0];

// A better approach:
assign out = in[7:0];

endmodule