module ROM(
    input [7:0] addr,
    output [15:0] dout
);

reg [15:0] mem [0:255];

initial begin
    for (int i = 0; i < 256; i++) begin
        case (i)
            0: mem[i] = 16'hA0A0;
            1: mem[i] = 16'hB1B1;
            2: mem[i] = 16'hC2C2;
            3: mem[i] = 16'hD3D3;
            default: mem[i] = 16'h0000; // Initialize other locations with a default value
        endcase
    end
end

assign dout = mem[addr];

endmodule