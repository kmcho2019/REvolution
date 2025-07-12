module ROM (
    input  wire        clk,
    input  wire [7:0]  addr,
    output reg  [15:0] dout
);

    // Hint to synthesis tools to infer block RAM or dedicated ROM macros
    (* rom_style = "block" *) reg [15:0] mem [0:255];

    initial begin
        mem[8'h00] = 16'hA0A0;
        mem[8'h01] = 16'hB1B1;
        mem[8'h02] = 16'hC2C2;
        mem[8'h03] = 16'hD3D3;
        // Other locations default to zero
    end

    always @(posedge clk) begin
        dout <= mem[addr];
    end

endmodule