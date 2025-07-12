module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

// Define the memory content directly
reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1] = '{ 
    16'hA0A0, 16'hB1B1, 16'hC2C2, 16'hD3D3, 
    // Add more initial values here if needed
    default: 16'h0000 // Initialize all other locations to 0
};

// Use assign to continuously output the data at the specified address
assign dout = mem[addr];

endmodule