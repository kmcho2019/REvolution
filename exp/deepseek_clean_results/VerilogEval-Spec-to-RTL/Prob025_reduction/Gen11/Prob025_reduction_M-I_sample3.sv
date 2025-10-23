module TopModule (
    input [7:0] in,
    output parity
);
    // Even parity calculation using XOR reduction
    // synthesis attribute keep_hierarchy of TopModule is "yes";
    assign parity = ^in;
endmodule