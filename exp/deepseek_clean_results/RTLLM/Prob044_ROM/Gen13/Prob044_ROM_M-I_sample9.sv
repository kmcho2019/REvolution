module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Sparse ROM implementation using case statement
    always @(*) begin
        case (addr)
            8'h00: dout = 16'hA0A0;
            8'h01: dout = 16'hB1B1;
            8'h02: dout = 16'hC2C2;
            8'h03: dout = 16'hD3D3;
            default: dout = 16'h0000; // Default to zero for unused addresses
        endcase
    end

    /* Design Notes:
     * - Eliminates unused memory array, reducing area
     * - Explicit default case prevents power waste from undefined states
     * - Maintains same combinational timing path
     * - More efficient for sparse ROMs (few used locations)
     * - Easier to modify specific locations without full array
     */
endmodule