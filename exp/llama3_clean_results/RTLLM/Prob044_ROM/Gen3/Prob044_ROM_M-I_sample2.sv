module ROM(
    input [7:0] addr,
    output reg [15:0] dout
);

reg [15:0] mem [0:255];

initial begin
    // Initialize the first four locations with specific values
    for (int i = 0; i < 4; i++) begin
        case (i)
            0: mem[i] = 16'hA0A0;
            1: mem[i] = 16'hB1B1;
            2: mem[i] = 16'hC2C2;
            3: mem[i] = 16'hD3D3;
        endcase
    end
    // Optionally, initialize the rest of the memory with a default value
    for (int i = 4; i < 256; i++) begin
        mem[i] = 16'h0000; // Default value, can be adjusted as needed
    end
end

always @(*) begin
    dout = mem[addr];
end

endmodule