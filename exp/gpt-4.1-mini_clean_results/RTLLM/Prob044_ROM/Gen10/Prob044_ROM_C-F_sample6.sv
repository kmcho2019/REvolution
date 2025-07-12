module ROM (
    input  [7:0] addr,
    output reg [15:0] dout
);

    (* rom_style = "block" *) reg [15:0] mem [0:255];

    integer i;
    initial begin
        // Initialize all memory locations to zero to avoid unknowns
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 16'h0000;
        end

        // Explicit initialization for specified addresses
        mem[8'h00] = 16'hA0A0;
        mem[8'h01] = 16'hB1B1;
        mem[8'h02] = 16'hC2C2;
        mem[8'h03] = 16'hD3D3;
    end

    always @(*) begin
        dout = mem[addr];
    end

endmodule