module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Memory bank declarations: 4 banks of 64 locations each
    reg [15:0] bank0 [0:63];
    reg [15:0] bank1 [0:63];
    reg [15:0] bank2 [0:63];
    reg [15:0] bank3 [0:63];

    // Initialize memory banks with distributed values
    initial begin
        // Bank 0 initialization
        bank0[0] = 16'hA0A0;  // Original addr 0
        bank0[1] = 16'h0000;
        // Bank 1 initialization
        bank1[0] = 16'hB1B1;  // Original addr 1
        bank1[1] = 16'h0000;
        // Bank 2 initialization
        bank2[0] = 16'hC2C2;  // Original addr 2
        bank2[1] = 16'h0000;
        // Bank 3 initialization
        bank3[0] = 16'hD3D3;  // Original addr 3
        bank3[1] = 16'h0000;
    end

    // Registered output for better timing
    always @(*) begin
        case (addr[7:6])
            2'b00: dout = bank0[addr[5:0]];
            2'b01: dout = bank1[addr[5:0]];
            2'b10: dout = bank2[addr[5:0]];
            2'b11: dout = bank3[addr[5:0]];
        endcase
    end

endmodule