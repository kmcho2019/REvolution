module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    // Use arithmetic addition to count number of ones
    assign out = in[0] + in[1] + in[2];
endmodule