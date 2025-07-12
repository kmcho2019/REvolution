module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Continuous read operation using case statement
    always @(*) begin
        case (addr)
            8'h00: dout = 16'hA0A0;
            8'h01: dout = 16'hB1B1;
            8'h02: dout = 16'hC2C2;
            8'h03: dout = 16'hD3D3;
            default: dout = 16'h0000; // All other addresses return zero
        endcase
    end

    /* Design Notes:
     * - Case statement implementation is more efficient for small ROMs
     * - All memory contents are directly visible in the code
     * - Default case ensures predictable behavior for all addresses
     * - No initialization needed as values are hardcoded
     */

endmodule