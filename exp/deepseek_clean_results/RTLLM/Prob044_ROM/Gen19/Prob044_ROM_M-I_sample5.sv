module ROM (
    input [7:0] addr,
    input en,          // Output enable
    output wire [15:0] dout
);

    // ROM implemented as case statement for area efficiency
    reg [15:0] rom_data;
    
    always @(*) begin
        case(addr)
            8'h00: rom_data = 16'hA0A0;
            8'h01: rom_data = 16'hB1B1;
            8'h02: rom_data = 16'hC2C2;
            8'h03: rom_data = 16'hD3D3;
            default: rom_data = 16'h0000;  // All other locations return 0
        endcase
    end

    // Gated output for power savings
    assign dout = en ? rom_data : 16'bz;

endmodule