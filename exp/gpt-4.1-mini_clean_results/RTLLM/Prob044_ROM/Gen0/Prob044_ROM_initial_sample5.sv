module ROM (
    input  wire [7:0]  addr,
    output reg  [15:0] dout
);

    reg [15:0] mem [0:255];

    initial begin
        mem[8'd0] = 16'hA0A0;
        mem[8'd1] = 16'hB1B1;
        mem[8'd2] = 16'hC2C2;
        mem[8'd3] = 16'hD3D3;
        // Other memory locations can be initialized here if needed
    end

    always @(*) begin
        dout = mem[addr];
    end

endmodule