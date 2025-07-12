module TopModule (
    input  [99:0] in,
    output [99:0] out
);

parameter WIDTH = 100;

// Direct vector reversal assignment
assign out = {in[0+:WIDTH]};

endmodule