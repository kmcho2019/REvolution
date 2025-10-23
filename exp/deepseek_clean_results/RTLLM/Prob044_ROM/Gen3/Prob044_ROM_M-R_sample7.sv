module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    parameter DEPTH = 256;
    parameter WIDTH = 16;
    
    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize memory using generate
    genvar i;
    generate
        // Initialize specific locations
        initial begin
            mem[0] = 16'hA0A0;
            mem[1] = 16'hB1B1;
            mem[2] = 16'hC2C2;
            mem[3] = 16'hD3D3;
        end
        
        // Initialize remaining locations to 0
        for (i = 4; i < DEPTH; i = i + 1) begin : init_mem
            initial mem[i] = {WIDTH{1'b0}};
        end
    endgenerate

    // Continuous read operation using assign
    assign dout = mem[addr];

endmodule