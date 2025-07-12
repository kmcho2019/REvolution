module ROM (
    input  [7:0]  addr,
    output [15:0] dout
);

    reg [15:0] mem [0:255];

    // Initialize entire memory to zero to avoid undefined values
    initial begin : init_mem
        integer i;
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 16'h0000;
        end
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    // Combinational read from ROM using continuous assignment
    assign dout = mem[addr];

endmodule