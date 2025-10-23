module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Segment 0: Addresses 0-63
    reg [15:0] seg0 [0:63];
    // Segment 1: Addresses 64-127
    reg [15:0] seg1 [0:63];
    // Segment 2: Addresses 128-191
    reg [15:0] seg2 [0:63];
    // Segment 3: Addresses 192-255
    reg [15:0] seg3 [0:63];

    // Initialize only segment 0 with our data
    initial begin
        seg0[0] = 16'hA0A0;
        seg0[1] = 16'hB1B1;
        seg0[2] = 16'hC2C2;
        seg0[3] = 16'hD3D3;
    end

    // Registered output for better timing
    always @(*) begin
        case(addr[7:6])
            2'b00: dout = seg0[addr[5:0]];  // Segment 0
            2'b01: dout = seg1[addr[5:0]];  // Segment 1
            2'b10: dout = seg2[addr[5:0]];  // Segment 2
            2'b11: dout = seg3[addr[5:0]];  // Segment 3
        endcase
    end

endmodule