module ROM (
    input  wire [7:0]  addr,
    output reg  [15:0] dout
);

    (* rom_style = "block" *) reg [15:0] mem [0:255];

    initial begin
        mem[8'h00] = 16'hA0A0;
        mem[8'h01] = 16'hB1B1;
        mem[8'h02] = 16'hC2C2;
        mem[8'h03] = 16'hD3D3;
        // Other locations default to 0 implicitly
    end

    always @(*) begin
        dout = mem[addr];
    end

endmodule