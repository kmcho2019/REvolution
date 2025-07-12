module ROM (
    input [7:0] addr,
    output wire [15:0] dout
);

    // Configurable memory parameters
    localparam MEM_DEPTH = 256;
    localparam MEM_WIDTH = 16;
    
    // Memory array declaration
    reg [MEM_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    // Initialize memory with specific values
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        
        // Optional: Initialize remaining locations to zero
        // for better power characteristics
        // for (int i = 4; i < MEM_DEPTH; i = i + 1) begin
        //     mem[i] = {MEM_WIDTH{1'b0}};
        // end
    end

    // Direct combinational read path
    assign dout = mem[addr];

endmodule