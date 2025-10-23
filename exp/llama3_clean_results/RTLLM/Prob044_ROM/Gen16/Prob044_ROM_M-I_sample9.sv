module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

// Use a more efficient memory type if supported by the target technology
// This might require specific synthesis directives or attributes
reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

initial begin
    // Initialize only the necessary locations to reduce power consumption
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Initialize the rest of the memory with a default value
    // This could help in reducing power consumption by minimizing switching activity
    for (int i = 4; i < 2**ADDR_WIDTH; i++) begin
        mem[i] = 16'h0000; // Default value, adjust according to needs
    end
end

always @(*) begin
    // Directly assign the output in the always block to minimize combinational logic
    dout = mem[addr];
end

endmodule