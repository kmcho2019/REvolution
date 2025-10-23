module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter DEPTH = 4
) (
    input clk,
    input read_en,
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

    // Memory array declaration with reduced depth
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize all memory contents
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Initialize remaining locations if DEPTH > 4
        for (integer i = 4; i < DEPTH; i = i + 1) begin
            mem[i] = {DATA_WIDTH{1'b0}};
        end
    end

    // Registered output for power savings
    always @(posedge clk) begin
        if (read_en) begin
            if (addr < DEPTH) begin
                dout <= mem[addr];
            end else begin
                dout <= {DATA_WIDTH{1'b0}};
            end
        end
    end

endmodule