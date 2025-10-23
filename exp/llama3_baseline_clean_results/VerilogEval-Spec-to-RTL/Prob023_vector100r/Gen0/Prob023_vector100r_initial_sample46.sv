module TopModule(
    input  [99:0] in,
    output [99:0] out
);

assign out = in[99:0];

// Alternative method using a loop
// integer i;
// always @(*) begin
//     for (i = 0; i < 100; i++) begin
//         out[99 - i] = in[i];
//     end
// end

endmodule