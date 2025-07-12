module TopModule (
    input [7:0] in,
    output parity
);
    wire group1_parity = ^in[3:0];  // Lower nibble parity
    wire group2_parity = ^in[7:4];  // Upper nibble parity
    
    assign parity = group1_parity ^ group2_parity;
endmodule