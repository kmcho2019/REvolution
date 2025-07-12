module ROM #(
    parameter WIDTH = 16,  // Width of the ROM
    parameter DEPTH = 256  // Depth of the ROM
)(
    input [7:0] addr,
    output reg [WIDTH-1:0] dout
);

reg [WIDTH-1:0] mem [0:DEPTH-1];

initial begin
    // Initialize memory locations with specific values
    for (int i = 0; i < DEPTH; i++) begin
        if (i < 4) begin
            case (i)
                0: mem[i] = 16'hA0A0;
                1: mem[i] = 16'hB1B1;
                2: mem[i] = 16'hC2C2;
                3: mem[i] = 16'hD3D3;
            endcase
        end else begin
            mem[i] = {WIDTH{1'b0}};  // Initialize other locations with zeros
        end
    end
end

always @(*) begin
    // Continuously output the data stored at the address specified by addr
    dout = mem[addr];
end

endmodule