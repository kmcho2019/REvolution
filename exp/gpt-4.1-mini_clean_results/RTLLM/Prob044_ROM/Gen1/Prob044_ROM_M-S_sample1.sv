module ROM (
    input  wire [7:0]  addr,
    output wire [15:0] dout
);

    reg [15:0] mem [0:255];

    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Other locations default to 0 (reg initializes to x by default in simulation,
        // but in synthesis it will be treated as 0 or fixed)
    end

    assign dout = mem[addr];

endmodule