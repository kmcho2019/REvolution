module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

// Define a smaller ROM module
module small_ROM #(
    parameter SIZE = 16
)(
    input [3:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

reg [DATA_WIDTH-1:0] mem [0:SIZE-1];

initial begin
    for (int i = 0; i < SIZE; i++) begin
        // Initialize with some pattern for demonstration
        mem[i] = {DATA_WIDTH{1'b0}} + i;
    end
end

always @(*) begin
    dout = mem[addr];
end

endmodule

// Use multiple small ROMs to form the larger ROM
wire [DATA_WIDTH-1:0] rom0_dout, rom1_dout, rom2_dout, rom3_dout;
small_ROM rom0(.addr(addr[3:0]), .dout(rom0_dout));
small_ROM rom1(.addr(addr[3:0]), .dout(rom1_dout));
small_ROM rom2(.addr(addr[3:0]), .dout(rom2_dout));
small_ROM rom3(.addr(addr[3:0]), .dout(rom3_dout));

// Select the appropriate ROM based on the higher bits of the address
always @(*) begin
    case (addr[7:4])
        4'h0: dout = rom0_dout;
        4'h1: dout = rom1_dout;
        4'h2: dout = rom2_dout;
        4'h3: dout = rom3_dout;
        default: dout = {DATA_WIDTH{1'b0}};
    endcase
end

endmodule