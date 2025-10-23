module ROM (
    input [7:0] addr,
    input oe,        // Output enable (active high)
    output [15:0] dout
);

    // Implement ROM as case statement instead of memory array
    // All undefined locations return 0 by default
    assign dout = oe ? 
        (addr == 8'd0) ? 16'hA0A0 :
        (addr == 8'd1) ? 16'hB1B1 :
        (addr == 8'd2) ? 16'hC2C2 :
        (addr == 8'd3) ? 16'hD3D3 :
        16'h0000 : 16'h0000;

endmodule