// TopModule: Passes input 'in' directly to output 'out' combinationally
module TopModule (
    input  wire in,
    output wire out
);

assign out = in;

endmodule