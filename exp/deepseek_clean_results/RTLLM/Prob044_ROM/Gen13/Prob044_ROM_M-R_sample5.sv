module ROM (
    input [7:0] addr,
    output wire [15:0] dout
);

    // Direct mapping from address to output using case statement
    assign dout = 
        (addr == 8'd0) ? 16'hA0A0 :
        (addr == 8'd1) ? 16'hB1B1 :
        (addr == 8'd2) ? 16'hC2C2 :
        (addr == 8'd3) ? 16'hD3D3 :
        16'h0000;  // Default all other addresses to 0

endmodule