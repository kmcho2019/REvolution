module ROM (
    input [1:0] addr,        // Reduced to 2 bits for 4 locations
    input oe_n,              // Output enable (active low)
    output reg [15:0] dout   // Registered output for clean gating
);

    // Memory array declaration: 4 locations of 16 bits each
    parameter DEPTH = 4;
    reg [15:0] mem [0:DEPTH-1];

    // Initialize all memory locations
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Remaining (if any) initialized to 0 by default
    end

    // Output with enable control
    always @(*) begin
        if (!oe_n)
            dout = mem[addr];
        else
            dout = 16'bz;    // High impedance when disabled
    end

endmodule