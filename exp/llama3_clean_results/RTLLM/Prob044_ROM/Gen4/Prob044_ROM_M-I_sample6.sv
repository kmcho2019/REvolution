// Improved version of the ROM module with focus on PPA optimization
module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input  wire [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

// Define the ROM memory array with synthesis attribute for potential optimization
(* rom_style = "block" *) reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

// Initial block to preload the ROM with fixed data, minimizing switching activity
initial begin
    // Explicitly initialize the first few locations with specific values
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Initialize other locations to zero to minimize switching activity and power consumption
    for (int i = 4; i < 2**ADDR_WIDTH; i++) begin
        mem[i] = {DATA_WIDTH{1'b0}};
    end
end

// Always block to output the data stored in the ROM, ensuring continuous update
always @(*) begin
    dout = mem[addr];
end

endmodule