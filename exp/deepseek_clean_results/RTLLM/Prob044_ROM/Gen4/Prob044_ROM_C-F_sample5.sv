module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Memory array declaration: 256 locations of 16 bits each
    (* ram_style = "block" *)  // Suggests block RAM implementation if available
    reg [15:0] mem [0:255];

    // Initialize memory contents
    initial begin
        // Initialize specific locations as given in requirements
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        
        // Initialize remaining locations to 0 for predictable power behavior
        for (integer i = 4; i < 256; i = i + 1) begin
            mem[i] = 16'h0000;
        end
    end

    // Continuous read operation - combinational for fastest access
    always @(*) begin
        dout = mem[addr];
    end

    // Note: For power optimization in systems with read enables,
    // consider adding a clocked version with read enable:
    /*
    reg [15:0] dout_reg;
    always @(posedge clk) begin
        if (read_en) begin
            dout_reg <= mem[addr];
        end
    end
    assign dout = dout_reg;
    */

endmodule