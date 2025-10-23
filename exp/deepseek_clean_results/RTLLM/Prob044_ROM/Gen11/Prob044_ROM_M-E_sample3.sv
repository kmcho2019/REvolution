module ROM (
    input clk,
    input en,          // Output enable
    input [7:0] addr,
    output reg [15:0] dout
);

    // Memory array declaration: 256 locations of 16 bits each
    reg [15:0] mem [0:255];
    wire gated_clk;

    // Clock gating cell
    assign gated_clk = clk & en;

    // Initialize only required memory locations
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    // Synchronous read operation with clock gating
    always @(posedge gated_clk) begin
        dout <= mem[addr];
    end

    // Output disable behavior
    always @(negedge en) begin
        if (!en) dout <= 16'h0000;
    end

endmodule