module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Special case handling for initialized values
    always @(*) begin
        case (addr)
            8'h00: dout = 16'hA0A0;
            8'h01: dout = 16'hB1B1;
            8'h02: dout = 16'hC2C2;
            8'h03: dout = 16'hD3D3;
            default: begin
                // Generate patterned data for other addresses
                // Using a simple XOR pattern as an example
                dout = {8'hAA ^ addr, 8'h55 ^ addr};
            end
        endcase
    end

endmodule