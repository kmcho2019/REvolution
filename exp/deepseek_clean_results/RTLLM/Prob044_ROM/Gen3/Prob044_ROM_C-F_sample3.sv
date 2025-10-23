module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter DEPTH = 256
)(
    input clk,                // Optional clock for registered output
    input read_en,            // Optional read enable
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

    // Memory array declaration
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize memory with predefined values
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        
        // Initialize remaining locations to 0
        for (integer i = 4; i < DEPTH; i = i + 1) begin
            mem[i] = {DATA_WIDTH{1'b0}};
        end
    end

    // Combinational read path
    wire [DATA_WIDTH-1:0] dout_comb = mem[addr];

    // Output selection: registered or combinational
    always @(posedge clk) begin
        if (read_en) begin
            dout <= dout_comb;
        end
    end

    // Fallback for pure combinational operation
    initial dout = {DATA_WIDTH{1'b0}};

endmodule