module ROM #(
    parameter DEFAULT = 16'h0000  // Default value for unspecified addresses
) (
    input [7:0] addr,
    output [15:0] dout
);

    // Implement ROM using case statement with parameterized default
    assign dout = 
        (addr == 8'd0) ? 16'hA0A0 :
        (addr == 8'd1) ? 16'hB1B1 :
        (addr == 8'd2) ? 16'hC2C2 :
        (addr == 8'd3) ? 16'hD3D3 :
        DEFAULT;  // Parameterized default value

endmodule