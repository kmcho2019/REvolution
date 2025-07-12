module ROM #(
    parameter NUM_ROMS = 4,
    parameter ROM_SIZE = 64,
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

localparam ROM_ADDR_WIDTH = $clog2(ROM_SIZE);

reg [DATA_WIDTH-1:0] rom_out [0:NUM_ROMS-1];
reg [ROM_ADDR_WIDTH-1:0] rom_addr [0:NUM_ROMS-1];

// Address decoder
always @(*) begin
    for (int i = 0; i < NUM_ROMS; i++) begin
        rom_addr[i] = addr[ROM_ADDR_WIDTH-1:0];
    end
end

// ROM instances
for (genvar i = 0; i < NUM_ROMS; i++) begin
    ROM_Instance #(
        .ROM_SIZE(ROM_SIZE),
        .ADDR_WIDTH(ROM_ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) rom_inst (
        .addr(rom_addr[i]),
        .dout(rom_out[i])
    );
end

// Output multiplexer
always @(*) begin
    case (addr[ADDR_WIDTH-1:ROM_ADDR_WIDTH])
        0: dout = rom_out[0];
        1: dout = rom_out[1];
        2: dout = rom_out[2];
        3: dout = rom_out[3];
        default: dout = 0;
    endcase
end

endmodule

module ROM_Instance #(
    parameter ROM_SIZE = 64,
    parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

reg [DATA_WIDTH-1:0] mem [0:ROM_SIZE-1];

initial begin
    // Initialize memory locations with specific values
    for (int i = 0; i < ROM_SIZE; i++) begin
        mem[i] = {16{1'b0}};
    end
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
end

always @(*) begin
    // Continuously output the data stored at the address specified by addr
    dout = mem[addr];
end

endmodule