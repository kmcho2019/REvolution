module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter NUM_LOCATIONS = 256
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

reg [DATA_WIDTH-1:0] mem [0:NUM_LOCATIONS-1];

initial begin
    for (int i = 0; i < NUM_LOCATIONS; i++) begin
        if (i == 0) mem[i] = 16'hA0A0;
        else if (i == 1) mem[i] = 16'hB1B1;
        else if (i == 2) mem[i] = 16'hC2C2;
        else if (i == 3) mem[i] = 16'hD3D3;
        else mem[i] = 16'h0000; // Initialize other locations with default value
    end
end

always @(*) begin
    if (addr < NUM_LOCATIONS) begin
        dout = mem[addr];
    end else begin
        dout = 16'h0000; // Default output for out-of-range addresses
    end
end

endmodule