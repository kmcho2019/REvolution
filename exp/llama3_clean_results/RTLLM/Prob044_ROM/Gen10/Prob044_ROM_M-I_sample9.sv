module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

// Simplified memory initialization using case statement
always @(*) begin
    case (addr)
        8'h0: dout = 16'hA0A0;
        8'h1: dout = 16'hB1B1;
        8'h2: dout = 16'hC2C2;
        8'h3: dout = 16'hD3D3;
        default: dout = 16'h0000; // Default value for other addresses
    endcase
end

endmodule