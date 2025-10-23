module ROM #(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 8
)(
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

    // Calculate required memory depth (4 locations in this case)
    localparam MEM_DEPTH = 4;
    
    // Memory array declaration with exact needed depth
    reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    // Initialize all memory locations
    integer i;
    initial begin
        // Initialize specified locations
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        
        // Initialize remaining locations (if any) to 0
        for (i = 4; i < MEM_DEPTH; i = i + 1) begin
            mem[i] = {DATA_WIDTH{1'b0}};
        end
    end

    // Address change detection to prevent unnecessary switching
    reg [ADDR_WIDTH-1:0] prev_addr;
    always @(*) begin
        if (addr !== prev_addr) begin
            dout = (addr < MEM_DEPTH) ? mem[addr] : {DATA_WIDTH{1'b0}};
            prev_addr = addr;
        end
    end

endmodule