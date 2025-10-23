module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

// Using a generate statement for dynamic input size handling is not needed here
// since our input size is fixed. However, for illustration purposes, here's how
// one might structure it for a dynamic size, assuming the size is a parameter:

parameter SIZE = 100;

// Direct assignment is still the most efficient way for fixed-size inputs
assign out_and = &in;
assign out_or  = |in;
assign out_xor = ^in;

// For illustration, if we were to use an always block for some reason, it would look like this:
// always @(*) begin
//     out_and = &in;
//     out_or  = |in;
//     out_xor = ^in;
// end

endmodule