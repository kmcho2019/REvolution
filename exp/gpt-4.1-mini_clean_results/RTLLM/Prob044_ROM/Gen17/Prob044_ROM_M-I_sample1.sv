module ROM (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  addr,
    output reg  [15:0] dout
);

    (* rom_style = "block" *) reg [15:0] mem [0:255];

    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        // Other memory locations default to zero implicitly
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            dout <= 16'h0000;
        else
            dout <= mem[addr];
    end

endmodule