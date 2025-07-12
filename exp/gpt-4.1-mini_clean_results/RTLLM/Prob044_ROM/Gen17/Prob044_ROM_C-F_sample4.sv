module ROM (
    input  wire [7:0]  addr,   // 8-bit address input selecting memory location
    output wire [15:0] dout    // 16-bit data output from ROM
);

    // Memory array with block RAM style attribute to encourage efficient implementation
    (* rom_style = "block" *) reg [15:0] mem [0:255];

    // Initialize only explicitly required memory locations;
    // others default to zero to minimize power and initialization overhead.
    initial begin
        mem[8'h00] = 16'hA0A0;
        mem[8'h01] = 16'hB1B1;
        mem[8'h02] = 16'hC2C2;
        mem[8'h03] = 16'hD3D3;
    end

    // Combinational continuous assignment for asynchronous read access;
    // outputs data stored at the given address.
    assign dout = mem[addr];

endmodule