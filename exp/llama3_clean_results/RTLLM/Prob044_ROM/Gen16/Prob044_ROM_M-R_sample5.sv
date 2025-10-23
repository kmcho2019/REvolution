module ROM(
    input [7:0] addr,
    output [15:0] dout
);

// Declare the memory array
reg [15:0] mem [0:255];
reg [15:0] dout;

// Initial block to pre-load the ROM with fixed data
initial begin
    // Initialize memory locations 0 through 3 with specific values
    mem[0] = 16'hA0A0;
    mem[1] = 16'hB1B1;
    mem[2] = 16'hC2C2;
    mem[3] = 16'hD3D3;
    // Other locations can be initialized as needed
end

// Always block to handle the output based on addr
always @(*) begin
    case (addr)
        8'h00: dout = mem[0];
        8'h01: dout = mem[1];
        8'h02: dout = mem[2];
        8'h03: dout = mem[3];
        // Add cases for other addresses as needed
        default: dout = 16'h0000; // Default output for unassigned addresses
    endcase
end

// Assign the output
assign dout = dout;

endmodule