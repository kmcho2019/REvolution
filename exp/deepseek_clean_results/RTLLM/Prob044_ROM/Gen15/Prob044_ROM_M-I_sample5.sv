module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Use case statement for sparse ROM implementation
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
     * - Eliminates 256x16 memory array when only 4 values are needed
     * - Case statement is more area-efficient for small ROMs
     * - Default case ensures clean power characteristics
     * - Same interface and functionality as original
     * - Better PPA for small ROM implementations
     */
endmodule