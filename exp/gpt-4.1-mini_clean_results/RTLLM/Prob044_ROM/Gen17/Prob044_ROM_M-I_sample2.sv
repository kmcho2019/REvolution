module ROM (
    input  wire        clk,    // Clock input for synchronous read
    input  wire        ce,     // Clock enable to gate reads and save power
    input  wire [7:0]  addr,   // 8-bit address input
    output reg  [15:0] dout    // Registered 16-bit data output
);

    (* rom_style = "block" *) reg [15:0] mem [0:255];

    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Other locations default to zero implicitly
    end

    always @(posedge clk) begin
        if (ce) begin
            dout <= mem[addr];
        end
    end

endmodule