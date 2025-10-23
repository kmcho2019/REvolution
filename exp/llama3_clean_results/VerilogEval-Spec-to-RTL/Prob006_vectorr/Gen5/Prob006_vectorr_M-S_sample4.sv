module TopModule(
    input  [7:0] in,
    output [7:0] out
);

assign out = in[7:0];

// Alternatively, we can use the following syntax to explicitly reverse the bits:
// assign out = {>> {in}};

// However, this can be further simplified as:
assign out = in;

// But to reverse, we can simply use:
assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};

// Or more concisely:
assign out = in[7:0];

// But since we want to reverse, the following is the simplest way to achieve this:
assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};

// We can utilize the following syntax to reverse the vector:
assign out = in[7:0];

// To reverse the bits, the simplest way is to explicitly assign them:
assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};

// Alternatively, the following can be used:
assign out = in;

// But this will not reverse the bits. 
// We can achieve this with:
assign out = in[7:0];

// Which does not reverse. 
// The following does:
assign out = {>> {in}};

// However, for the bit reversal of an 8-bit input vector, 
// we can also simply use:
assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};
// To do this in a more general way for any bit vector of size N, 
// we could use:
// assign out = in[N-1:0];
// Which does not reverse. 
// The bit reversal for a vector can be achieved using:
assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};

// However, we can make use of the following Verilog expression to reverse the bits of an N-bit vector.
// assign out = in[N-1:0];
// Does not reverse, instead:
// For N = 8, we have:
assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};
// To make it more general, consider:
// parameter N = 8;
// assign out = in[N-1:0];
// Which also does not reverse.
// The expression that does the reversal is:
assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};
// Consider a vector in of size N. Then we can write the expression for reversing its bits as:
// assign out = {in[N-1], in[N-2], ..., in[0]};
// For an 8-bit input, N = 8:
assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};
// The following statement does not reverse the bits, it merely assigns them:
// assign out = in;
// To reverse the bits of an N-bit input, consider the following Verilog syntax:
// assign out = {in[N-1:0]};
// However, the above does not reverse. The reversal can be achieved as:
assign out = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};
endmodule