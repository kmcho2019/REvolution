module ROM (
    input  wire [7:0]  addr,
    output wire [15:0] dout
);

    // ROM content defined as a constant array using localparam
    localparam [15:0] mem [0:255] = {
        16'hD3D3, 16'hC2C2, 16'hB1B1, 16'hA0A0, // reversed order to match indexes 0..3
        // Initialize remaining locations with zeros
        {252{16'h0000}}
    };

    // Continuous assignment for asynchronous ROM output
    assign dout = mem[addr];

endmodule