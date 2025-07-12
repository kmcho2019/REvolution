module ROM #(
    parameter WIDTH = 16,
    parameter DEPTH = 256
)(
    input clk,
    input rst_n,
    input oe_n,         // Output enable (active low)
    input [7:0] addr,
    output reg [WIDTH-1:0] dout
);

    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize memory with clear formatting
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Default other locations to 0
        for (integer i = 4; i < DEPTH; i = i + 1)
            mem[i] = {WIDTH{1'b0}};
    end

    // Registered read operation with output enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout <= {WIDTH{1'b0}};
        end
        else if (!oe_n) begin
            dout <= mem[addr];
        end
        else begin
            dout <= {WIDTH{1'b0}};
        end
    end

endmodule