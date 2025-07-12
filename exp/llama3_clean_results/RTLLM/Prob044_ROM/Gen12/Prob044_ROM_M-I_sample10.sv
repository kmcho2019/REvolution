module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

initial begin
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Initialize other locations as needed
    for (int i = 4; i < 2**ADDR_WIDTH; i++) begin
        mem[i] = 16'h0000; // Initialize other locations with zeros
    end
end

always @(*) begin
    case (addr)
        8'h0: dout = mem[0];
        8'h1: dout = mem[1];
        8'h2: dout = mem[2];
        8'h3: dout = mem[3];
        default: dout = mem[addr]; // Use the address to directly select the output
    endcase
end

endmodule