module ROM (
    input clk,            // Clock for registered output
    input [7:0] addr,
    output reg [15:0] dout
);

    // Segmented memory architecture (4 segments of 64 words)
    reg [15:0] seg0 [0:63];
    reg [15:0] seg1 [0:63];
    reg [15:0] seg2 [0:63];
    reg [15:0] seg3 [0:63];
    
    // Segment enable signals
    wire seg0_en = (addr[7:6] == 2'b00);
    wire seg1_en = (addr[7:6] == 2'b01);
    wire seg2_en = (addr[7:6] == 2'b10);
    wire seg3_en = (addr[7:6] == 2'b11);
    
    // Internal data buses
    wire [15:0] seg0_data = seg0_en ? seg0[addr[5:0]] : 16'b0;
    wire [15:0] seg1_data = seg1_en ? seg1[addr[5:0]] : 16'b0;
    wire [15:0] seg2_data = seg2_en ? seg2[addr[5:0]] : 16'b0;
    wire [15:0] seg3_data = seg3_en ? seg3[addr[5:0]] : 16'b0;
    
    // Initialize memory segments
    initial begin
        // Segment 0 - Special values
        seg0[0] = 16'hA0A0;
        seg0[1] = 16'hB1B1;
        seg0[2] = 16'hC2C2;
        seg0[3] = 16'hD3D3;
        for (int i = 4; i < 64; i++) begin
            seg0[i] = 16'h0000;
        end
        
        // Segment 1 - Pattern generator
        for (int i = 0; i < 64; i++) begin
            seg1[i] = {8'hAA, i[7:0]};
        end
        
        // Segment 2 - Checksum pattern
        for (int i = 0; i < 64; i++) begin
            seg2[i] = i + (i << 8);
        end
        
        // Segment 3 - Fibonacci sequence
        seg3[0] = 16'h0000;
        seg3[1] = 16'h0001;
        for (int i = 2; i < 64; i++) begin
            seg3[i] = seg3[i-1] + seg3[i-2];
        end
    end

    // Registered output with segment mux
    always @(posedge clk) begin
        case (addr[7:6])
            2'b00: dout <= seg0_data;
            2'b01: dout <= seg1_data;
            2'b10: dout <= seg2_data;
            2'b11: dout <= seg3_data;
        endcase
    end

endmodule