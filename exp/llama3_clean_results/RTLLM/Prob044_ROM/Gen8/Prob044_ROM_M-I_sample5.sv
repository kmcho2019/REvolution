module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input clk,
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout,
    output reg parity_error
);

localparam MEM_SIZE = 2**ADDR_WIDTH;
reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

initial begin
    // Initialize memory locations 0 through 3 with specific values
    $readmemh("rom_data.hex", mem);
end

always @ (posedge clk) begin
    // Assign dout based on addr
    dout <= mem[addr];
    
    // Simple parity check: Calculate parity of mem[addr] and compare with the LSB
    parity_error <= (dout[15:1] ^ {15{1'b0}}) != dout[0];
end

endmodule