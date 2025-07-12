module ROM(
    input [7:0] addr,
    output reg [15:0] dout
);

// Define the memory array with 256 locations, each 16 bits wide.
reg [15:0] mem [0:255];

// Initial block to pre-load the ROM with fixed data.
initial begin
    // Initialize memory locations 0 through 3 with specific values.
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    
    // Optionally, initialize the rest of the memory to zero for clarity.
    // This is implicitly done in Verilog, but explicit initialization can improve readability.
    for (int i = 4; i < 256; i++) begin
        mem[i] = 16'h0000;
    end
end

// Always block to continuously output the data stored in the ROM at the specified address.
always @(*) begin
    // Directly assign the output based on the addr input.
    dout = mem[addr];
end

endmodule