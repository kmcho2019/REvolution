module ROM(
    input [7:0] addr,
    output reg [15:0] dout
);

reg [15:0] mem [0:255];

initial begin
    // Initialize memory locations using a loop for scalability
    for (int i = 0; i < 256; i++) begin
        if (i == 0) mem[i] = 16'hA0A0;
        else if (i == 1) mem[i] = 16'hB1B1;
        else if (i == 2) mem[i] = 16'hC2C2;
        else if (i == 3) mem[i] = 16'hD3D3;
        // Add more initializations as needed
        else mem[i] = 16'h0000; // Default value for other locations
    end
end

always @(*) begin
    // Directly assign the output from the memory location
    dout = mem[addr];
end

endmodule