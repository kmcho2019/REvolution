module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Memory array: 256x16 ROM (can be reduced if fewer locations are needed)
    reg [15:0] mem [0:255];

    // Initialize memory - explicit values for used locations, zeros for unused
    initial begin
        // Required initialized locations
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        
        // Initialize unused locations to zero for consistent behavior
        for (integer i = 4; i < 256; i = i + 1) begin
            mem[i] = 16'h0000;
        end
    end

    // Combinational read operation - outputs data immediately when address changes
    always @(*) begin
        dout = mem[addr];
    end

    /* Area Optimization Note:
     * If only locations 0-3 are needed, consider reducing array size to [0:3]
     * For patterned data, consider replacing memory with generation logic
     */

endmodule