module ROM #(
    parameter DEPTH = 4,
    parameter WIDTH = 16
)(
    input clk,
    input read_en,
    input [$clog2(DEPTH)-1:0] addr,
    output reg [WIDTH-1:0] dout
);

    // Memory array declaration with exact needed depth
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize all memory contents
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Initialize remaining locations if DEPTH > 4
        for (integer i = 4; i < DEPTH; i = i + 1) begin
            mem[i] = {WIDTH{1'b0}};
        end
    end

    // Registered read operation
    always @(posedge clk) begin
        if (read_en) begin
            dout <= mem[addr];
        end
    end

endmodule