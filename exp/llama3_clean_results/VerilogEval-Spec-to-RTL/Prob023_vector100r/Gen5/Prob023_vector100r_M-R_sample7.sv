module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// Utilize Verilog's bit indexing feature to reverse the bits
assign out = in[99:0];

// Alternatively, you can use a for loop to generate the reversed bits:
// genvar i;
// generate
//     for (i = 0; i < 100; i++) begin
//         assign out[i] = in[99 - i];
//     end
// endgenerate

endmodule