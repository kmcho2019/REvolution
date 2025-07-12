module ROM (
    input  wire [7:0]  addr,
    output wire [15:0] dout
);

    reg [15:0] mem [0:255];

    initial begin
        mem[8'h00] = 16'hA0A0;
        mem[8'h01] = 16'hB1B1;
        mem[8'h02] = 16'hC2C2;
        mem[8'h03] = 16'hD3D3;
        // Other memory locations can be initialized here as needed
    end

    assign dout = mem[addr];

endmodule