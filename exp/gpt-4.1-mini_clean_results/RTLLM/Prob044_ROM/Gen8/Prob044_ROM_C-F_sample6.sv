module ROM (
    input  wire [7:0]  addr,
    output wire [15:0] dout
);

    // Synthesis attribute to infer block RAM for ROM
    (* rom_style = "block" *) reg [15:0] mem [0:255];

    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Other memory locations default initialized by synthesis tool
    end

    // Combinational read: output reflects data at addr immediately
    assign dout = mem[addr];

endmodule