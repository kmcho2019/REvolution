module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Clear population count with explicit zero-extension
    assign out = (2'b00 + in[0] + in[1] + in[2]);
endmodule