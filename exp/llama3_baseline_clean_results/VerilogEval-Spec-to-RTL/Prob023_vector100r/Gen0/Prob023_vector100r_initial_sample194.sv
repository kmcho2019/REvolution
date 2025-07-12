module TopModule (
    input  [99:0] in,  // 100-bit input
    output [99:0] out  // 100-bit output
);

assign out = in[99:0];  // Directly assign the input to output in reverse order

// Alternatively, using a for loop for clarity
// assign out = {>>{in}};

// Or explicitly using a for loop in a generate block
// generate
//     genvar i;
//     for (i = 0; i < 100; i++) begin
//         assign out[99 - i] = in[i];
//     end
// endgenerate

endmodule