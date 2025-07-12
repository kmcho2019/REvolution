module ROM(
    input [7:0] addr,
    output reg [15:0] dout
);

// Declare the memory array
reg [15:0] mem [0:255];

// Use a more efficient method to initialize the memory array
initial begin
    // Example: Loading from an external file or using a loop to populate the array
    $readmemh("rom_data.hex", mem);
    // or
    for (int i = 0; i < 256; i++) begin
        mem[i] = {16'hA0, 16'hA0} + (i * 16'h10);
    end
end

// Optimize the combinational logic for output
always @(*) begin
    dout = mem[addr];
end

endmodule