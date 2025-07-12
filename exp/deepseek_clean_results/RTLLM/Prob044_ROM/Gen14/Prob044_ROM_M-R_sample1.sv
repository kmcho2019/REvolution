module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    parameter MEM_SIZE = 256;
    parameter DATA_WIDTH = 16;
    
    // Memory array declaration
    reg [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];

    // Initialize memory with specific values
    integer i;
    initial begin
        for (i = 0; i < MEM_SIZE; i = i + 1) begin
            case (i)
                0: mem[i] = 16'hA0A0;
                1: mem[i] = 16'hB1B1;
                2: mem[i] = 16'hC2C2;
                3: mem[i] = 16'hD3D3;
                default: mem[i] = 16'h0000;
            endcase
        end
    end

    // Combinational read path using always block
    always @(*) begin
        dout = mem[addr];
    end

endmodule