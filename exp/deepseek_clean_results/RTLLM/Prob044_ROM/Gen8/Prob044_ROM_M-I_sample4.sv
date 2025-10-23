module ROM (
    input [7:0] addr,
    input oe,            // Output enable (active high)
    output reg [15:0] dout  // Registered output for clean transitions
);

    // Parameter for memory depth (only need 4 locations)
    parameter DEPTH = 4;
    parameter WIDTH = 16;
    
    // Memory array declaration: only needed locations
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize memory using case statement
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    // Output with enable control
    always @(*) begin
        if (oe) begin
            if (addr < DEPTH)
                dout = mem[addr];
            else
                dout = {WIDTH{1'b0}}; // Return zeros for out-of-range addresses
        end else begin
            dout = {WIDTH{1'bz}};      // High-Z when disabled
        end
    end

endmodule