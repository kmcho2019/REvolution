module TopModule (
    input [7:0] in,
    output [31:0] out
);

// Conditionally assign the output based on the sign of the input
assign out = (in[7] == 0) ? {24'd0, in} : {24'd1, in};

endmodule