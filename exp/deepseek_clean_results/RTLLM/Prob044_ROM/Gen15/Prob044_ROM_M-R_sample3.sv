module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // Implement ROM as case statement
    assign dout = get_rom_value(addr);

    // Address decoding function
    function automatic [15:0] get_rom_value(input [7:0] addr);
        case (addr)
            8'h00: get_rom_value = 16'hA0A0;
            8'h01: get_rom_value = 16'hB1B1;
            8'h02: get_rom_value = 16'hC2C2;
            8'h03: get_rom_value = 16'hD3D3;
            default: get_rom_value = 16'h0000; // Default to 0 for undefined addresses
        endcase
    endfunction

    /* Design Notes:
     * - Case statement implementation is more efficient for small ROMs
     * - No memory array needed - values directly mapped to addresses
     * - Default case ensures defined behavior for all addresses
     * - Same functionality as original with simpler structure
     */
endmodule