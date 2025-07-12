module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

// Utilize a more efficient data type for the memory array if supported by the synthesis tool
reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

initial begin
    // Initialize only the required memory locations to reduce area and power
    for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
        if (i <= 3) begin
            case (i)
                0: mem[i] = 16'hA0A0;
                1: mem[i] = 16'hB1B1;
                2: mem[i] = 16'hC2C2;
                3: mem[i] = 16'hD3D3;
                default: mem[i] = 16'h0000; // Initialize other locations with zeros
            endcase
        end else begin
            mem[i] = 16'h0000; // Default initialization for other locations
        end
    end
end

always @(*) begin
    // Directly assign the output for simplicity and efficiency
    dout = mem[addr];
end

endmodule