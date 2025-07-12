module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter ROM_SIZE = 2**ADDR_WIDTH
) (
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

reg [DATA_WIDTH-1:0] mem [0:ROM_SIZE-1];

initial begin
    // Initialize memory locations with specific values
    for (int i = 0; i < 4; i++) begin
        case (i)
            0: mem[i] = 16'hA0A0;
            1: mem[i] = 16'hB1B1;
            2: mem[i] = 16'hC2C2;
            3: mem[i] = 16'hD3D3;
            default: mem[i] = 16'h0000;
        endcase
    end
    // Initialize other locations with a default value
    for (int i = 4; i < ROM_SIZE; i++) begin
        mem[i] = 16'h0000;
    end
end

// Use continuous assignment to output the data stored at the address specified by addr
assign dout = mem[addr];

endmodule