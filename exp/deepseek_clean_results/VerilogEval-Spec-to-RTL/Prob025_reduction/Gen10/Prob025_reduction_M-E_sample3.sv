module TopModule (
    input [7:0] in,
    output parity
);
    wire lower_nibble_parity = ^in[3:0];
    wire upper_nibble_parity = ^in[7:4];
    assign parity = lower_nibble_parity ^ upper_nibble_parity;
endmodule