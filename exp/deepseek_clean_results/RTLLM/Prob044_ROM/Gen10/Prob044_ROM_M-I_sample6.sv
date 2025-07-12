module ROM (
    input [1:0] addr,      // Reduced to 2 bits for 4 locations
    input oe_n,            // Active-low output enable
    output reg [15:0] dout  // Registered output for clean gating
);

    // Memory array declaration: 4 locations of 16 bits each
    reg [15:0] mem [0:3];

    // Initialize memory locations
    integer i;
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Alternative initialization pattern:
        // for (i=0; i<4; i=i+1) mem[i] = 16'hA0A0 + (i * 16'h1111);
    end

    // Output with enable control
    always @(*) begin
        if (~oe_n)
            dout = mem[addr];
        else
            dout = 16'bz;  // High impedance when disabled
    end

endmodule