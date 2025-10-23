module ROM (
    input  wire [7:0]  addr,
    output wire [15:0] dout
);

    (* rom_style = "block" *) reg [15:0] mem [0:255];

    integer i;
    initial begin
        // Initialize all locations to zero explicitly
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 16'h0000;
        end
        // Overwrite first four locations with specified values
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    assign dout = mem[addr];

endmodule