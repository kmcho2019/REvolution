module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Pattern-based ROM implementation
    always @(*) begin
        case(addr)
            8'h00: dout = 16'hA0A0;
            8'h01: dout = 16'hB1B1;
            8'h02: dout = 16'hC2C2;
            8'h03: dout = 16'hD3D3;
            default: dout = {8'h01, addr} + 16'h8080; // Pattern: 0x01AA + 0x8080
        endcase
    end

    /* Pattern explanation:
       For addr = 4: 0x0104 + 0x8080 = 0x8184
       For addr = 5: 0x0105 + 0x8080 = 0x8185
       This creates a predictable yet non-trivial pattern for all addresses >3
       while maintaining the original values for addresses 0-3
    */
endmodule