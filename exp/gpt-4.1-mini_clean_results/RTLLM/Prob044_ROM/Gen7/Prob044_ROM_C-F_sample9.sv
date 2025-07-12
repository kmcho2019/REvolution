module ROM (
    input  wire [7:0]  addr,
    output reg  [15:0] dout
);

    reg [15:0] mem [0:255];

    integer i;
    initial begin
        // Initialize all memory to zero to avoid X states and ensure defined contents
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 16'h0000;
        end
        // Initialize specific memory locations with given values
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    always @(*) begin
        dout = mem[addr];
    end

endmodule