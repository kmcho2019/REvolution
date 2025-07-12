module ROM(
    input logic [7:0] addr,
    output logic [15:0] dout
);

logic [15:0] mem_block0 [0:63];
logic [15:0] mem_block1 [0:63];
logic [15:0] mem_block2 [0:63];
logic [15:0] mem_block3 [0:63];

initial begin
    // Initialize memory blocks
    for (int i = 0; i < 64; i++) begin
        mem_block0[i] = (i < 4)? (i == 0)? 16'hA0A0 : (i == 1)? 16'hB1B1 : (i == 2)? 16'hC2C2 : 16'hD3D3 : 16'h0000;
        mem_block1[i] = 16'h0000;
        mem_block2[i] = 16'h0000;
        mem_block3[i] = 16'h0000;
    end
end

always_comb begin
    // Address decoding
    logic [1:0] block_select;
    logic [5:0] block_addr;
    block_select = addr[7:6];
    block_addr = addr[5:0];

    // Memory folding
    case (block_select)
        2'b00: dout = mem_block0[block_addr];
        2'b01: dout = mem_block1[block_addr];
        2'b10: dout = mem_block2[block_addr];
        2'b11: dout = mem_block3[block_addr];
        default: dout = 16'h0000;
    endcase
end

endmodule