module ROM (
    input  wire [7:0]  addr,
    output reg  [15:0] dout
);

    // Four smaller 64x16 ROM blocks
    (* rom_style = "block" *) reg [15:0] mem0 [0:63];
    (* rom_style = "block" *) reg [15:0] mem1 [0:63];
    (* rom_style = "block" *) reg [15:0] mem2 [0:63];
    (* rom_style = "block" *) reg [15:0] mem3 [0:63];

    // Initialize mem0 with known data, rest zeros by default
    initial begin
        // mem0 locations 0-3 initialized
        mem0[0] = 16'hA0A0;
        mem0[1] = 16'hB1B1;
        mem0[2] = 16'hC2C2;
        mem0[3] = 16'hD3D3;
        // others zero
        integer i;
        for (i = 4; i < 64; i = i + 1) begin
            mem0[i] = 16'h0000;
        end
        // zero initialize others explicitly to avoid latches or X's
        for (i = 0; i < 64; i = i + 1) begin
            mem1[i] = 16'h0000;
            mem2[i] = 16'h0000;
            mem3[i] = 16'h0000;
        end
    end

    always @(*) begin
        case (addr[7:6])
            2'b00: dout = mem0[addr[5:0]];
            2'b01: dout = mem1[addr[5:0]];
            2'b10: dout = mem2[addr[5:0]];
            2'b11: dout = mem3[addr[5:0]];
            default: dout = 16'h0000;
        endcase
    end

endmodule