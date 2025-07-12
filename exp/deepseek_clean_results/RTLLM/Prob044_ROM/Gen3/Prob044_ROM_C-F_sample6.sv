module ROM #(
    parameter DEPTH = 256,           // Adjustable memory depth
    parameter REGISTERED_OUT = 0    // Optional output register
)(
    input [7:0] addr,                // 8-bit address input
    input clk,                       // Optional clock for registered output
    input read_en,                   // Optional read enable
    output reg [15:0] dout           // 16-bit data output
);

    // Memory array declaration with parameterized depth
    reg [15:0] mem [0:DEPTH-1];

    // Initialize memory with fixed values
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        
        // Initialize remaining locations to 0
        for (integer i = 4; i < DEPTH; i = i + 1) begin
            mem[i] = 16'h0000;
        end
    end

    // Combinational read path (default)
    generate
        if (!REGISTERED_OUT) begin
            always @(*) begin
                if (read_en) dout = mem[addr];
                else dout = 16'h0000; // Output zeros when not reading
            end
        end
        else begin
            // Registered output for better timing
            always @(posedge clk) begin
                if (read_en) dout <= mem[addr];
                else dout <= 16'h0000;
            end
        end
    endgenerate

endmodule