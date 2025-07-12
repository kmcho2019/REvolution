module TopModule (
    input [2:0] in,
    output [1:0] out
);
    assign out[0] = ^in;  // Optimal odd-count detection
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);  // Minimal majority function
endmodule