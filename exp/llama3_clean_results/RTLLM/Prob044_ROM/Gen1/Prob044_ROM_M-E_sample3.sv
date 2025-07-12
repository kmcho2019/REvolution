module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

reg [DATA_WIDTH-1:0] dout;

always @(*) begin
    case (addr)
        8'h00: dout = 16'hA0A0;
        8'h01: dout = 16'hB1B1;
        8'h02: dout = 16'hC2C2;
        8'h03: dout = 16'hD3D3;
        // Add more cases as needed for other addresses
        default: dout = 16'h0000; // Default value for unspecified addresses
    endcase
end

endmodule