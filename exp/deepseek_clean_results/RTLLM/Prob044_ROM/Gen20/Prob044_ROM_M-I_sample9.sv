module ROM #(
    parameter DEPTH = 256,
    parameter WIDTH = 16
)(
    input clk,
    input rst_n,
    input read_en,
    input [7:0] addr,
    output reg [WIDTH-1:0] dout
);

    // Memory array declaration with configurable parameters
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize all memory contents to zero (better for power estimation)
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            mem[i] = {WIDTH{1'b0}};
        end
        // Set specific values for used locations
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    // Registered read operation with enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout <= {WIDTH{1'b0}};
        end
        else if (read_en) begin
            dout <= mem[addr];
        end
    end

endmodule