module ROM (
    input  wire [7:0]  addr,
    output wire [15:0] dout
);

    reg [15:0] mem [0:255];

    integer i;
    initial begin
        // Initialize first four memory locations with specific values
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Initialize remaining memory locations to zero to avoid undefined states
        for (i = 4; i < 256; i = i + 1) begin
            mem[i] = 16'h0000;
        end
    end

    // Continuous combinational assignment for output
    assign dout = mem[addr];

endmodule