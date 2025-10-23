module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

localparam MEM_SIZE = 2**ADDR_WIDTH;
reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

// Using a more efficient initial block to initialize memory locations
initial begin
    for (int i = 0; i < MEM_SIZE; i++) begin
        if (i == 0) mem[i] = 16'hA0A0;
        else if (i == 1) mem[i] = 16'hB1B1;
        else if (i == 2) mem[i] = 16'hC2C2;
        else if (i == 3) mem[i] = 16'hD3D3;
        // Other locations can be initialized as needed
        else mem[i] = 16'h0000; // Initialize other locations to zero
    end
end

// Maintaining the existing combinational logic for performance
always @(*) begin
    // Continuously output the data stored at the address specified by addr
    dout = mem[addr];
end

endmodule