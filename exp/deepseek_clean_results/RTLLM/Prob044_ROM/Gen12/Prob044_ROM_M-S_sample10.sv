module ROM (
    input [7:0] addr,
    output wire [15:0] dout
);

    // Simplified implementation using case statement
    assign dout = (addr == 0) ? 16'hA0A0 :
                 (addr == 1) ? 16'hB1B1 :
                 (addr == 2) ? 16'hC2C2 :
                 (addr == 3) ? 16'hD3D3 :
                 16'h0000;

endmodule