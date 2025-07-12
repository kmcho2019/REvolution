module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Case-based ROM implementation
    always @(*) begin
        case (addr)
            8'h00: dout = 16'hA0A0;
            8'h01: dout = 16'hB1B1;
            8'h02: dout = 16'hC2C2;
            8'h03: dout = 16'hD3D3;
            default: dout = 16'h0000; // All other addresses return 0
        endcase
    end

    /* Design Notes:
     * - No memory array declaration needed
     * - Each value is explicitly mapped to its address
     * - Default case ensures clean output for unspecified addresses
     * - More efficient for small ROMs (4-16 entries typically)
     * - Easier to see all stored values at a glance
     * - Synthesis tool can optimize the case statement efficiently
     */
endmodule