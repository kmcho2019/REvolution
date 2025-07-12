module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Clear and efficient population count
    assign out = ^in[2:0] + ^in[1:0] + in[0];

endmodule