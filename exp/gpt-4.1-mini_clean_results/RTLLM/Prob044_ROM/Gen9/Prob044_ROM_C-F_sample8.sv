module ROM (
    input  wire [7:0]  addr,
    output wire [15:0] dout
);

    // Attribute to instruct synthesis to use block RAM for ROM implementation
    (* rom_style = "block" *) reg [15:0] mem [0:255];

    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Other memory locations left to default initialization
    end

    // Combinational output reflecting ROM content at addr asynchronously
    assign dout = mem[addr];

endmodule